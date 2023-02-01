FROM debian:stretch-slim

WORKDIR /src

RUN apt-get update && apt-get install --no-install-recommends git -y && apt install --no-install-recommends -y cmake pkg-config libssl-dev git build-essential clang libclang-dev curl libz-dev && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --default-toolchain nightly
RUN . ~/.cargo/env && rustup target add wasm32-unknown-unknown --toolchain nightly && cargo install cargo-deb

CMD bash