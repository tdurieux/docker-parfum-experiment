FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && \
    apt-get install ca-certificates wget unzip patch python3 postgresql-client osm2pgsql \
            -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*