FROM rust:slim-buster as build

WORKDIR /app

COPY . /app
USER root

RUN apt-get update
RUN apt-get install libssl-dev pkg-config -y
RUN cargo build --release

# Copy the binary into a new container for a smaller docker image
FROM debian:buster-slim

WORKDIR /etc/lust

RUN apt-get update \
    && apt-get install -y ca-certificates libssl-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/release/lust ./
USER root

ENTRYPOINT ["./lust", "--host", "0.0.0.0"]
