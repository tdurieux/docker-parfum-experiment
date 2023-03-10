FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y g++-aarch64-linux-gnu libc6-dev-arm64-cross && rm -rf /var/lib/apt/lists/*;

RUN rustup default nightly
RUN rustup target add aarch64-unknown-linux-gnu

WORKDIR /app

ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc \
    CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc \
    CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++


CMD ["make", "hello_world_aarch64_docker"]
