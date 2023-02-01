FROM rust:latest

RUN apt-get update && \
 apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y protobuf-compiler cmake && \
 sudo apt-get install --no-install-recommends -y nano net-tools tcpdump iproute2 netcat ngrep atop gdb strace clang && \
 sudo apt-get clean && \
 sudo rm -r /var/lib/apt/lists/*

WORKDIR /starcoin
COPY rust-toolchain /starcoin/rust-toolchain
RUN rustup install $(cat rust-toolchain)
