FROM ubuntu:xenial

RUN apt-get update && apt-get -y --no-install-recommends install \
    curl unzip git build-essential ca-certificates libssl-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /spire
