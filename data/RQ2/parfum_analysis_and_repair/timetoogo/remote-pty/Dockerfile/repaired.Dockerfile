FROM cruizba/ubuntu-dind

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc build-essential gdb curl file autoconf zip netcat lsof \
    linux-headers-generic && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN $HOME/.cargo/bin/rustup target add x86_64-unknown-linux-musl

ENTRYPOINT [ "bash" ]