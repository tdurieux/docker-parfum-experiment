FROM rust:latest

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential cmake pkg-config libssl-dev clang libclang-dev llvm && rm -rf /var/lib/apt/lists/*;

ARG TOOLCHAIN=nightly-2021-03-15
RUN rustup toolchain install ${TOOLCHAIN}
RUN rustup default ${TOOLCHAIN}
RUN rustup component add rustfmt
RUN rustup target add wasm32-unknown-unknown --toolchain ${TOOLCHAIN}

RUN cargo install sccache --features "gcs"