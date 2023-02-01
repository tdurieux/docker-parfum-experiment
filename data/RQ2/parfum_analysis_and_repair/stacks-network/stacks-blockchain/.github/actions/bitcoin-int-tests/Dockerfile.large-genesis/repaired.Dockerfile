FROM rust:bullseye AS test

WORKDIR /src

COPY . .

RUN cd / && wget https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0-x86_64-linux-gnu.tar.gz
RUN cd / && tar -xvzf bitcoin-0.20.0-x86_64-linux-gnu.tar.gz && rm bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

RUN ln -s /bitcoin-0.20.0/bin/bitcoind /bin/

RUN rustup override set nightly-2022-01-14 && \
    rustup component add llvm-tools-preview && \
    cargo install grcov

ENV RUSTFLAGS="-Zinstrument-coverage" \
    LLVM_PROFILE_FILE="stacks-blockchain-%p-%m.profraw"

RUN cargo test --no-run --workspace && \
    cargo build --workspace

ENV BITCOIND_TEST 1
RUN cd testnet/stacks-node && cargo test --release --features prod-genesis-chainstate -- --test-threads 1 --ignored neon_integrations::bitcoind_integration_test

RUN grcov . --binary-path ./target/debug/ -s . -t lcov --branch --ignore-not-existing --ignore "/*" -o lcov.info

FROM scratch AS export-stage
COPY --from=test /src/lcov.info /
