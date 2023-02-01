## -----------------------------------------------------------------------------
## Build
## -----------------------------------------------------------------------------
FROM rust:1.56.1-slim-buster as build-stage

RUN apt update && apt install -y --no-install-recommends \
  pkg-config \
  libssl-dev \
  libcurl4-openssl-dev \
  libpq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR "/build"

# Install and build crates
COPY Cargo.* /build/
RUN mkdir /build/src && echo "fn main() {}" > /build/src/main.rs
RUN cargo build --release

# Build app
COPY src/ /build/src/
RUN touch src/main.rs && cargo build --release

## -----------------------------------------------------------------------------
## Package
## -----------------------------------------------------------------------------
FROM debian:buster

RUN apt update && apt install -y --no-install-recommends \
  ca-certificates \
  libssl1.1 \
  libcurl4 \
  libpq5 && rm -rf /var/lib/apt/lists/*;

COPY --from=build-stage "/build/target/release/conference" "/app/conference"

WORKDIR "/app"
ENTRYPOINT ["/app/conference"]
