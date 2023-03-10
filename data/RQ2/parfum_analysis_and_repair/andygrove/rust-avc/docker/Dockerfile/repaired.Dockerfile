FROM ubuntu:latest
RUN apt-get update && apt-get -y --no-install-recommends install curl vim build-essential sudo libssl-dev gcc-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;

# Install Rust and Cargo
RUN curl -f https://sh.rustup.rs > sh.rustup.rs \
    && sh sh.rustup.rs -y \
    && . $HOME/.cargo/env \
    && echo 'source $HOME/.cargo/env' >> $HOME/.bashrc \
    && rustup update \
    && rustup default nightly-2016-09-05 \
    && rustup target add arm-unknown-linux-gnueabihf

VOLUME /rust-avc
VOLUME /rust-qik
