###########################
# The golang build container
FROM golang:1.17-buster as cosmos-go

WORKDIR /usr/src/agoric-sdk/golang/cosmos
COPY go.mod go.sum ../../
RUN go mod download

COPY golang/cosmos ./

ARG GIT_COMMIT
RUN make GIT_COMMIT="$GIT_COMMIT" MOD_READONLY= compile-go

###############################
# OTEL fetch
# from https://github.com/open-telemetry/opentelemetry-collector-releases/releases

FROM node:16-buster AS otel

ARG OTEL_VERSION=0.48.0
ARG OTEL_HASH_arm64=846852f4c34f6e494abe202402fdf1d17e2ec3c7a7f96985b6011126ae553249
ARG OTEL_HASH_amd64=7c6923ecbc045e6d8825479d836d3e8b8a2b3c20185e9dda531b3aa2b973459c

RUN set -eux; \
  pkgArch="$(dpkg --print-architecture)"; \
  eval "otelHash=\$OTEL_HASH_${pkgArch}"; \
  wget -O otel.tgz "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol-contrib_${OTEL_VERSION}_linux_${pkgArch}.tar.gz"; \
  echo "${otelHash}  otel.tgz" | sha256sum -c -; \
  tar -C / -xzf otel.tgz && rm otel.tgz


###############################
# The js build container
FROM node:16-buster AS build-js

# When changing/adding entries here, make sure to search the whole project for
# `@@AGORIC_DOCKER_SUBMODULES@@`
ARG MODDABLE_COMMIT_HASH
ARG MODDABLE_URL
ARG XSNAP_NATIVE_COMMIT_HASH
ARG XSNAP_NATIVE_URL

WORKDIR /usr/src/agoric-sdk
COPY . .

# add retry for qemu arm64 network fetching and mui issues with qemu
RUN bash -c "for i in {1..3}; do yarn install --network-timeout 1000000 && exit 0 || (echo retrying; sleep 15;) done; exit 1"

# Need to build the Node.js node extension that uses our above Golang shared library.
COPY --from=cosmos-go /usr/src/agoric-sdk/golang/cosmos/build golang/cosmos/build/
RUN cd golang/cosmos && yarn build:gyp

# Install the entry points in GOBIN.
RUN cd packages/cosmic-swingset && make install-local install-helper install-agd

# Check out the specified submodule versions.
# When changing/adding entries here, make sure to search the whole project for
# `@@AGORIC_DOCKER_SUBMODULES@@`
RUN \
  MODDABLE_COMMIT_HASH="$MODDABLE_COMMIT_HASH" \
  MODDABLE_URL="$MODDABLE_URL" \
  XSNAP_NATIVE_COMMIT_HASH="$XSNAP_NATIVE_COMMIT_HASH" \
  XSNAP_NATIVE_URL="$XSNAP_NATIVE_URL" \
  yarn build

# Remove dev dependencies.
RUN rm -rf packages/xsnap/moddable
# FIXME: This causes bundling differences.  https://github.com/endojs/endo/issues/919
# RUN yarn install --frozen-lockfile --production --network-timeout 100000

###############################
# The install container.
FROM node:16-buster AS install

# Install some conveniences.
RUN apt-get --allow-releaseinfo-change update && apt-get install --no-install-recommends -y vim jq less && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
COPY --from=build-js /usr/src/agoric-sdk agoric-sdk
COPY --from=build-js /root/go/bin/agd /usr/local/bin/
COPY --from=build-js /root/go/bin/ag-cosmos-helper /usr/local/bin/
COPY --from=otel /otelcol-contrib /usr/local/bin/
RUN ln -s /usr/src/agoric-sdk/packages/cosmic-swingset/bin/ag-chain-cosmos /usr/local/bin/
RUN ln -s /usr/src/agoric-sdk/packages/solo/bin/ag-solo /usr/local/bin/
RUN ln -s /usr/src/agoric-sdk/packages/agoric-cli/bin/agoric /usr/local/bin/
COPY . lib/ag-solo/

ARG GIT_REVISION=unknown
RUN echo "$GIT_REVISION" > /usr/src/agoric-sdk/packages/solo/public/git-revision.txt

# Compatibility links for older containers.
RUN ln -s /data /agoric
RUN ln -s /data/solo /usr/src/agoric-sdk/packages/cosmic-swingset/solo
RUN ln -s /data/chains /usr/src/agoric-sdk/packages/cosmic-swingset/chains

# By default, run the daemon with specified arguments.
WORKDIR /root
EXPOSE 1317 9090 26657
ENTRYPOINT [ "/usr/src/agoric-sdk/packages/cosmic-swingset/scripts/chain-entry.sh" ]
