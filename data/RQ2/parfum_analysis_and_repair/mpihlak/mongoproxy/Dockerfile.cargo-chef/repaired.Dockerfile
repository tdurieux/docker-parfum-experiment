FROM rust:1.47.0-buster as planner
WORKDIR /build
RUN cargo install cargo-chef --version 0.1.9
COPY . .
RUN cargo chef prepare  --recipe-path recipe.json

FROM rust:1.47.0-buster as cacher
WORKDIR /build
RUN cargo install cargo-chef --version 0.1.9
COPY --from=planner /build/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

FROM rust:1.47.0-buster as builder
WORKDIR /build
COPY . .
COPY --from=cacher /build/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo
RUN cargo build --release --bin mongoproxy

FROM debian:buster-slim
RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN adduser --uid 9999 --disabled-password --gecos '' mongoproxy
USER mongoproxy
WORKDIR /mongoproxy
COPY --from=builder /build/target/release/mongoproxy ./
COPY iptables-init.sh .
