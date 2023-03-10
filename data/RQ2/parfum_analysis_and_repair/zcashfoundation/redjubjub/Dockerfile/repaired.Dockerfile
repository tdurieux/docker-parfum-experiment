FROM rust:stretch as base

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	make cmake g++ gcc && rm -rf /var/lib/apt/lists/*;

RUN mkdir /redjubjub
WORKDIR /redjubjub

ENV RUST_BACKTRACE 1
ENV CARGO_HOME /redjubjub/.cargo/

# Copy local code to the container image.
# Assumes that we are in the git repo.

COPY . .

RUN cargo fetch --verbose

COPY . .

RUN rustc -V; cargo -V; rustup -V; cargo test --all && cargo build --release
