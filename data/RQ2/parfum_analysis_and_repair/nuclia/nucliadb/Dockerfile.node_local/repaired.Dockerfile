FROM rust:buster AS builder

ARG CARGO_FEATURES=release-feature-set
ARG CARGO_PROFILE=release

# Labels
LABEL maintainer="info@nuclia.com"
LABEL org.opencontainers.image.vendor="Nuclia Inc."

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install ca-certificates \
                          cmake \
                          libpq-dev \
                          libpq5 \
                          libssl-dev \
                          openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Required by tonic
RUN rustup component add rustfmt

COPY . /nucliadb

WORKDIR /nucliadb

RUN echo "Building workspace with feature(s) '$CARGO_FEATURES' and profile '$CARGO_PROFILE'" \
    && cargo build \
        --features $CARGO_FEATURES -p nucliadb_node \
        $(test "$CARGO_PROFILE" = "release" && echo "--release") \
    && echo "Copying binaries to /nucliadb/bin" \
    && mkdir -p /nucliadb/bin \
    && find target/$CARGO_PROFILE -maxdepth 1 -perm /a+x -type f -exec mv {} /nucliadb/bin \;

FROM debian:buster-slim AS nucliadb

ENV VECTORS_DIMENSION=768
ENV VECTORS_DISTANCE=cosine
ENV DATA_PATH=data
ENV RUST_LOG=nucliadb_node=DEBUG
ENV RUST_BACKTRACE=1


RUN apt-get -y update \
    && apt-get -y --no-install-recommends install ca-certificates curl \
                          libpq5 \
                          libssl1.1 \
                          lmdb-utils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /nucliadb/bin/node_reader /usr/local/bin/node_reader
COPY --from=builder /nucliadb/bin/node_writer /usr/local/bin/node_writer

RUN curl -f -L -o /bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/v0.3.1/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

COPY nucliadb_node/entrypoint.sh /
RUN chmod 750 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]