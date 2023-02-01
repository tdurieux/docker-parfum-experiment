FROM rust:slim

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    pkg-config \
    libsqlite3-dev \
    curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://get.docker.com/ | sh

RUN cargo install diesel_cli --no-default-features --features "sqlite"

COPY ./ /home

RUN mkdir /home/snippets

WORKDIR /home

ENV DOCKER_ENV=true
