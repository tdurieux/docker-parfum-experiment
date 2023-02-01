FROM rust:1.62

ENV CARGO_TERM_COLOR always
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev cmake && rm -rf /var/lib/apt/lists/*;

# create empty project for caching dependencies
RUN USER=root cargo new --bin /planets-service/docker-build
COPY /common-utils/ ./planets-service/common-utils/
WORKDIR /planets-service/docker-build
COPY /Cargo.lock ./
COPY /planets-service/Cargo.toml ./
# cache dependencies
RUN cargo install --path . --locked

COPY /planets-service/ ./
RUN cargo install --path . --locked

FROM debian:bookworm-slim
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev curl && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /usr/local/cargo/bin/planets-service /usr/local/bin/planets-service
CMD ["planets-service"]
