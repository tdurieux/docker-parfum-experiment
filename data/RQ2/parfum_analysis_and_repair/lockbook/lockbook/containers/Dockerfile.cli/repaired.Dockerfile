ARG HASH
FROM rust:1.59 AS cli-build
RUN rustup component add rustfmt
RUN rustup component add clippy

# CLI depends on core via a relative import
COPY core/Cargo.toml /core/Cargo.toml
COPY containers/dummy.rs /core/src/lib.rs

COPY containers/dummy.rs /core/libs/models/src/lib.rs
COPY core/libs/models/Cargo.toml /core/libs/models/Cargo.toml
COPY containers/dummy.rs /core/libs/crypto/src/lib.rs
COPY core/libs/crypto/Cargo.toml /core/libs/crypto/Cargo.toml


# Required to get cargo to get and compile deps but not our source
# https://blog.mgattozzi.dev/caching-rust-docker-builds/
COPY containers/dummy.rs /clients/cli/src/main.rs
COPY clients/cli/Cargo.toml /clients/cli/Cargo.toml
COPY rustfmt.toml /clients/cli/rustfmt.toml

WORKDIR /clients/cli
RUN cargo build --release

# Build our source
COPY clients/cli /clients/cli
COPY core /core
# Cargo thinks this file hasn't changed on the filesystem
RUN touch /clients/cli/src/main.rs
RUN touch /core/src/lib.rs
RUN touch /core/libs/models/src/lib.rs
RUN touch /core/libs/crypto/src/lib.rs
RUN cargo build --release

# Check formatting
FROM cli:${HASH} AS cli-fmt
RUN cargo fmt -- --check -l

# Check lint
FROM cli:${HASH} AS cli-lint
RUN cargo clippy -- -D warnings

# Run cli tests
FROM cli:${HASH} AS cli-test
RUN cargo test --release