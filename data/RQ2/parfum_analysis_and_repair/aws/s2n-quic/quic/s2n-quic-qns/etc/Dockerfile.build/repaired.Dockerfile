FROM rust:latest as planner
WORKDIR app
RUN cargo install cargo-chef --version 0.1.23
COPY Cargo.toml /app
COPY common /app/common
COPY quic /app/quic
# Don't include testing crates
RUN rm -rf quic/s2n-quic-bench quic/s2n-quic-events quic/s2n-quic-sim
RUN cargo chef prepare  --recipe-path recipe.json

FROM rust:latest as cacher
WORKDIR app
RUN cargo install cargo-chef --version 0.1.23
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --recipe-path recipe.json

FROM rust:latest AS builder
WORKDIR app

RUN set -eux; \
  apt-get update; \
  apt-get install --no-install-recommends -y cmake clang; rm -rf /var/lib/apt/lists/*;

# copy sources
COPY Cargo.toml /app
COPY common /app/common
COPY quic /app/quic
# Don't include testing crates
RUN rm -rf quic/s2n-quic-bench quic/s2n-quic-events quic/s2n-quic-sim

# Copy over the cached dependencies
COPY --from=cacher /app/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo

# build runner
ARG release="false"
RUN set -eux; \
  if [ "$release" = "true" ]; then \
    RUSTFLAGS="-C link-arg=-s -C panic=abort" \
      cargo build --bin s2n-quic-qns --release; \
    cp target/release/s2n-quic-qns .; \
  else \
    cargo build --bin s2n-quic-qns; \
    cp target/debug/s2n-quic-qns .; \
  fi; \
  rm -rf target

FROM martenseemann/quic-network-simulator-endpoint:latest

ENV RUST_BACKTRACE="1"

# copy entrypoint
COPY quic/s2n-quic-qns/etc/run_endpoint.sh .
RUN chmod +x run_endpoint.sh

# copy runner
COPY --from=builder /app/s2n-quic-qns /usr/bin/s2n-quic-qns
RUN set -eux; \
  chmod +x /usr/bin/s2n-quic-qns; \
  ldd /usr/bin/s2n-quic-qns; \
  # ensure the binary works \
  s2n-quic-qns --help; \
  echo done

ARG tls
ENV TLS="${tls}"

# enable unstable crypto optimizations for testing
ENV S2N_UNSTABLE_CRYPTO_OPT_TX=100
ENV S2N_UNSTABLE_CRYPTO_OPT_RX=100
