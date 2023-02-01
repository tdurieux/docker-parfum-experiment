FROM rust:1.62

ENV CARGO_TERM_COLOR always
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# create empty project for caching dependencies
RUN USER=root cargo new --bin /satellites-service/docker-build
WORKDIR /satellites-service/docker-build
COPY /Cargo.lock ./
COPY /satellites-service/Cargo.toml ./
# cache dependencies
RUN cargo install --path . --locked

COPY /satellites-service/ ./
RUN cargo install --path . --locked

FROM debian:bookworm-slim
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev curl && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /usr/local/cargo/bin/satellites-service /usr/local/bin/satellites-service
CMD ["satellites-service"]
