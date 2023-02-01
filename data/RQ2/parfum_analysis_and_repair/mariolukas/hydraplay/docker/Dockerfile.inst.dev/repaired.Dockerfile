FROM debian:buster-slim

RUN apt update && \
    apt install --no-install-recommends -y git curl wget && rm -rf /var/lib/apt/lists/*;