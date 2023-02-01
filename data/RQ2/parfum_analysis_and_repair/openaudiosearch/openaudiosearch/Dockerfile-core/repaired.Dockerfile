# frontend-build: build frontend with yarn
FROM node:14-alpine as frontend-build
WORKDIR /app/frontend
COPY frontend /app/frontend
RUN yarn && yarn run build

# use the cargo-chef base image
FROM lukemathwalker/cargo-chef:latest-rust-1.56-slim-buster as base

# prepare the cargo-chef build
FROM base as planner
WORKDIR app
COPY Cargo.toml .
COPY rust rust
RUN cargo chef prepare  --recipe-path recipe.json

# build dependencies with cargo-chef
FROM base as cacher
WORKDIR app
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

# build the main binary
FROM base as builder
WORKDIR app
COPY Cargo.toml .
COPY rust rust
COPY config config
# copy the built frontend
COPY --from=frontend-build /app/frontend/dist frontend/dist
# copy the built dependencies from previous image
COPY --from=cacher /app/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo
ENV BUILD_FRONTEND="0"
RUN cargo build --release --bin oas

# build the main image
FROM debian:buster-slim as runtime
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
WORKDIR app
COPY --from=builder /app/target/release/oas /usr/local/bin
CMD ["/usr/local/bin/oas", "run"]
