FROM rust:latest AS FETCH_THE_EFFIN_RUST
RUN rustup default nightly
WORKDIR /app
COPY ./Cargo.toml /app/Cargo.toml
COPY ./Cargo.lock /app/Cargo.lock
COPY ./src/lib.rs /app/src/lib.rs
RUN cargo fetch

COPY ./src /app/src
RUN cargo build --release --bin testies

FROM debian:latest
WORKDIR /app
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY --from=FETCH_THE_EFFIN_RUST /app/target/release/testies /app
COPY ./run-client2 /app
CMD ["./run-client2"]
