# Build Nimbus in a stock debian container
FROM debian:bullseye-slim as builder

# Included here to avoid build-time complaints
ARG DOCKER_TAG

ARG BUILD_TARGET

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git libpcre3-dev ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
RUN bash -c "git clone https://github.com/status-im/nim-beacon-chain && cd nim-beacon-chain && git config advice.detachedHead false && git fetch --all --tags && git checkout ${BUILD_TARGET} && \
	make -j$(nproc) nimbus_beacon_node"

# Pull all binaries into a second stage deploy debian container
FROM debian:bullseye-slim

ARG USER=user
ARG UID=10002

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends \
  ca-certificates bash tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
        apt-get update; \
        apt-get install --no-install-recommends -y gosu; \
        rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
        gosu nobody true

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/usr/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

RUN mkdir -p /var/lib/nimbus && chown ${USER}:${USER} /var/lib/nimbus && chmod 700 /var/lib/nimbus

# Copy executable
COPY --from=builder /usr/src/nim-beacon-chain/build/nimbus_beacon_node /usr/local/bin/nimbus_beacon_node
# Scripts for privilege change and validator import
COPY ./validator-import.sh /usr/local/bin/
COPY ./docker-entrypoint.sh /usr/local/bin/

USER ${USER}

ENTRYPOINT ["nimbus_beacon_node"]
