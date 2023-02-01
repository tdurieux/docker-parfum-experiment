FROM ubuntu:20.04
COPY rust-toolchain /tmp/rust-toolchain
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl pkg-config libssl-dev git jq unzip && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $(cat /tmp/rust-toolchain)
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add clippy && rustup component add rustfmt