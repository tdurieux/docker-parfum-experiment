FROM rust

RUN apt-get update && \
    apt-get install --no-install-recommends libclang-dev -y && \
    apt-get install --no-install-recommends nodejs -y && \
    apt-get install --no-install-recommends npm -y && \
    apt-get install --no-install-recommends binaryen -y && rm -rf /var/lib/apt/lists/*;

RUN npm install -g n && \
    npm install -g yarn && \
    n stable && npm cache clean --force;

RUN curl -sSf https://sh.rustup.rs/ | sh -s -- --default-toolchain nightly -y

RUN rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
RUN rustup target add wasm32-unknown-unknown

RUN cargo install cargo-dylint dylint-link

# While Redspot didn't merge `--skip-linting` https://github.com/patractlabs/redspot/pull/181
# we will use our version of `cargo-contract` without linting
# RUN cargo install --force cargo-contract && \
RUN cargo install cargo-contract --git https://github.com/Supercolony-net/cargo-contract --force && \
    cargo install contracts-node --git https://github.com/paritytech/substrate-contracts-node.git --force --locked
