FROM rust:1.57.0-buster

RUN apt-get update && apt-get -y --no-install-recommends install clang llvm libclang-dev && rm -rf /var/lib/apt/lists/*;
RUN rustup --version; \
    cargo --version; \
    rustc --version; \
    cargo install cargo-tarpaulin;

WORKDIR /home/pyrsia

ENTRYPOINT ["cargo", "tarpaulin", "--workspace"]
