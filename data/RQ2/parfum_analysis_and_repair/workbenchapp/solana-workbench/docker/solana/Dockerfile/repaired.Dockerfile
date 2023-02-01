FROM rust:slim-buster

RUN rustup toolchain install nightly && rustup default nightly && rustup component add rustfmt
RUN apt-get update && apt-get install --no-install-recommends -y git pkg-config libudev-dev make libclang-dev clang cmake && rm -rf /var/lib/apt/lists/*;
ENV SOLANA_VERSION v1.9.20
RUN git clone -b $SOLANA_VERSION --depth 1 https://github.com/solana-labs/solana
WORKDIR solana
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/solana/target/release/build \
    --mount=type=cache,target=/solana/target/release/deps \
    --mount=type=cache,target=/solana/target/release/incremental \
    cargo build --release

FROM debian:bullseye-slim

RUN apt-get update && apt-get install --no-install-recommends -y bzip2 && rm -rf /var/lib/apt/lists/*;
VOLUME ["/var/lib/solana-ledger"]
COPY --from=0 /solana/target/release/* /usr/local/bin
