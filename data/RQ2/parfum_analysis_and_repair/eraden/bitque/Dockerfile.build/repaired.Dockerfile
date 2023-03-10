FROM ubuntu:18.04

WORKDIR /app/

RUN apt-get update && apt-get install --no-install-recommends -y curl git openssl libpq-dev gcc openssl1.0 make cmake && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y
RUN . $HOME/.cargo/env && \
    rustup toolchain install nightly && rustup default nightly

RUN ls -al /app
CMD . $HOME/.cargo/env && \
    cd ./jirs-server && \
    rm -Rf ./target/debug/jirs_server && \
    cargo build --bin jirs_server --release --no-default-features --features local-storage && \
    cp /app/target/release/jirs_server /app/build/
