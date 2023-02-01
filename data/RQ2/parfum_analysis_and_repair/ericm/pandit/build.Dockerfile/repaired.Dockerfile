FROM rust

RUN apt update && apt install --no-install-recommends -y cmake clang protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN rustup toolchain install nightly

RUN rustup default nightly

RUN rustup component add rustfmt --toolchain nightly