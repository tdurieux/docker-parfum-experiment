FROM rust:1.31
RUN apt-get update && apt-get install --no-install-recommends -y cmake libgit2-dev musl-tools && rm -rf /var/lib/apt/lists/*;
RUN rustup target add x86_64-unknown-linux-musl
RUN apt-get install --no-install-recommends -y clang libclang-dev && rm -rf /var/lib/apt/lists/*;
RUN cargo install bindgen
RUN rustup component add rustfmt-preview
