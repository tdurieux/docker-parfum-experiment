FROM rust:bullseye

WORKDIR /src/

COPY . .

WORKDIR /src/testnet/stacks-node

RUN rustup override set nightly-2022-01-14 && \
    rustup component add llvm-tools-preview && \
    cargo install grcov

ENV RUSTFLAGS="-Zinstrument-coverage" \
    LLVM_PROFILE_FILE="stacks-blockchain-%p-%m.profraw"

RUN cargo test --no-run && \
    cargo build

RUN cd / && wget https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0-x86_64-linux-gnu.tar.gz
RUN cd / && tar -xvzf bitcoin-0.20.0-x86_64-linux-gnu.tar.gz && rm bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

RUN ln -s /bitcoin-0.20.0/bin/bitcoind /bin/

ENV BITCOIND_TEST 1
