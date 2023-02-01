# Azure pipeline require glibc based image
FROM debian:buster-slim

RUN apt update && \
    apt install --no-install-recommends -y git make gcc python && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts