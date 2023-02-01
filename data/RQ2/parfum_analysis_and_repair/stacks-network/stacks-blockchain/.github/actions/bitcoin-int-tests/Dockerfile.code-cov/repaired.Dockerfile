FROM rust:bullseye AS test

WORKDIR /build

RUN rustup override set nightly-2022-01-14 && \
    rustup component add llvm-tools-preview && \
    cargo install grcov

ENV RUSTFLAGS="-Zinstrument-coverage" \
    LLVM_PROFILE_FILE="stacks-blockchain-%p-%m.profraw"
    
COPY . .

RUN cargo build --workspace && \
    cargo test --workspace

# Generate coverage report and upload it to codecov
RUN grcov . --binary-path ./target/debug/ -s . -t lcov --branch --ignore-not-existing --ignore "/*" -o lcov.info

FROM scratch AS export-stage
COPY --from=test /build/lcov.info /