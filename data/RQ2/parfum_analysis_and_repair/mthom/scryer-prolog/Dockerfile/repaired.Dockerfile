# See https://github.com/LukeMathWalker/cargo-chef
ARG RUST_VERSION=1.60-buster
FROM rust:${RUST_VERSION} as planner
WORKDIR /scryer-prolog
RUN cargo install cargo-chef 
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM rust:${RUST_VERSION} as cacher
WORKDIR /scryer-prolog
RUN cargo install cargo-chef
COPY --from=planner /scryer-prolog/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

FROM rust:${RUST_VERSION} as builder
WORKDIR /scryer-prolog
COPY . .
# Copy over the cached dependencies