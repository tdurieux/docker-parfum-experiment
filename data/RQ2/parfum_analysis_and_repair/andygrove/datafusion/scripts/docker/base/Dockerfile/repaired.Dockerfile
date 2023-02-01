FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl vim pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN ~/.cargo/bin/rustup default nightly
