# Reference: https://www.lpalmieri.com/posts/fast-rust-docker-builds/

FROM rust:1.58 as cargo-chef-rust
RUN cargo install cargo-chef

FROM cargo-chef-rust as planner
WORKDIR app
# We only pay the installation cost once,
# it will be cached from the second build onwards
# To ensure a reproducible build consider pinning
# the cargo-chef version with `--version X.X.X`
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM cargo-chef-rust as cacher
WORKDIR app
COPY --from=planner /app/recipe.json recipe.json
RUN rustup component add rustfmt
RUN cargo chef cook --release --recipe-path recipe.json

FROM cargo-chef-rust as builder
WORKDIR app
COPY . .
# Copy over the cached dependencies