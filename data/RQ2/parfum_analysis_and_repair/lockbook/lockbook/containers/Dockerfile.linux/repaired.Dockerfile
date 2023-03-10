ARG HASH
FROM ubuntu:jammy AS linux-build

RUN apt update && apt install --no-install-recommends -y curl build-essential libglib2.0-dev libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libgraphene-1.0-dev libgtk-4-dev libgtksourceview-5-dev && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup component add rustfmt
RUN rustup component add clippy

WORKDIR linux

# Linux depends on core via a relative import
COPY core/Cargo.toml /core/Cargo.toml
COPY core/libs/models/Cargo.toml /core/libs/models/Cargo.toml
COPY core/libs/crypto/Cargo.toml /core/libs/crypto/Cargo.toml

# Required to get cargo to get and compile deps but not our source
# https://blog.mgattozzi.dev/caching-rust-docker-builds/
COPY containers/dummy.rs /core/src/lib.rs
COPY containers/dummy.rs /core/libs/models/src/lib.rs
COPY containers/dummy.rs /core/libs/crypto/src/lib.rs

COPY containers/dummy.rs src/main.rs
COPY clients/linux/Cargo.toml .
COPY rustfmt.toml .
RUN cargo build --release

# Build our source
COPY clients/linux .
COPY core /core

# Cargo thinks this file hasn't changed on the filesystem
RUN touch src/main.rs
RUN touch /core/src/lib.rs
RUN touch /core/libs/models/src/lib.rs
RUN touch /core/libs/crypto/src/lib.rs
RUN cargo build --release

# Check the formatting of core
FROM linux:${HASH} AS linux-fmt
RUN cargo fmt -- --check -l

# Check the lint of core
FROM linux:${HASH} AS linux-lint
RUN cargo clippy -- -D warnings

# Run core tests
FROM linux:${HASH} AS linux-test
RUN cargo test --release
