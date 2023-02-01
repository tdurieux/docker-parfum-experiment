FROM rust:1.33.0-slim

RUN apt-get update -y && apt-get install -y libssl-dev \
    pkg-config \
    libsqlite3-dev \
    curl

RUN curl -sSL https://get.docker.com/ | sh

RUN cargo install diesel_cli --no-default-features --features "sqlite"

COPY ./ /home

WORKDIR /home

ENV DOCKER_ENV=true
