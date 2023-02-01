FROM rust:latest as build
WORKDIR /build
COPY Cargo.lock Cargo.toml ./
COPY src/ ./src/
RUN cargo build --release

FROM debian:stretch-slim
COPY --from=build /build/target/release/dirscan /bin/
RUN apt-get update && apt-get install --no-install-recommends -y pv && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["dirscan"]
