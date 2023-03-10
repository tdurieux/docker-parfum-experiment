FROM rust:bullseye

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
        $(test "$CARGO_PROFILE" = "release" && echo "--release")