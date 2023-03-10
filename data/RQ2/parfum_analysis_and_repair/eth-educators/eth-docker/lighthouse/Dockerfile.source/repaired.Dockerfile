# Build Lighthouse in a stock Rust build container
FROM rust:latest as builder

ARG BUILD_TARGET

RUN apt-get update && apt-get install -y git gcc g++ make cmake libclang-dev clang pkg-config llvm-dev libssl-dev patch --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
RUN bash -c "git clone https://github.com/sigp/lighthouse.git && cd lighthouse && git config advice.detachedHead false && git fetch --all --tags && git checkout ${BUILD_TARGET} && make"

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

ARG USER=lhconsensus
ARG UID=10002

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
RUN mkdir -p /var/lib/lighthouse/beacon && chown ${USER}:${USER} /var/lib/lighthouse/beacon && chmod 700 /var/lib/lighthouse/beacon
COPY ./docker-entrypoint.sh /usr/local/bin/

ARG USER=lhvalidator
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
RUN mkdir -p /var/lib/lighthouse/validators && chown ${USER}:${USER} /var/lib/lighthouse/validators && chmod 700 /var/lib/lighthouse/validators

# Copy executable
COPY --from=builder /usr/local/cargo/bin/lighthouse /usr/local/bin/

# Scripts that handle permissions
COPY ./validator-import.sh /usr/local/bin/
COPY ./validator-exit.sh /usr/local/bin/

# For voluntary exit
ENV KEYSTORE=nonesuch

USER lhconsensus

ENTRYPOINT ["lighthouse"]
