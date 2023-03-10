# Build Lighthouse in a stock Rust build container
FROM rust:latest as builder

ARG BUILD_TARGET=master

RUN apt-get update && apt-get install -y git gcc g++ make cmake libclang-dev clang pkg-config llvm-dev libssl-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
RUN bash -c "git clone https://github.com/akula-bft/akula && cd akula && git config advice.detachedHead false && git fetch --all --tags && git checkout ${BUILD_TARGET} && cargo build --all --profile=production"

# Pull all binaries into a second stage deploy debian container
FROM debian:bullseye-slim

# Unused, this is here to avoid build time complaints
ARG DOCKER_TAG

RUN set -eux; \
        apt-get update; \
        apt-get install --no-install-recommends -y gosu; \
        rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
        gosu nobody true

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends \
  libssl-dev \
  ca-certificates \
  wget \
  tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG USER=akula
ARG UID=10000

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

# Create data mount point with permissions
RUN mkdir -p /var/lib/akula && chown ${USER}:${USER} /var/lib/akula && chmod 700 /var/lib/akula

# Copy executable
COPY --from=builder /usr/src/akula/target/production/akula /usr/src/akula/target/production/akula-rpc /usr/src/akula/target/production/akula-sentry /usr/src/akula/target/production/akula-toolbox /usr/local/bin/

USER akula

ENTRYPOINT ["akula"]
