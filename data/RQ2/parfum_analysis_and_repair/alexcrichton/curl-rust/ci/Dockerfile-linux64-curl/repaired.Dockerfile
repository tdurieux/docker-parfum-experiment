FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc ca-certificates make libc6-dev \
  libssl-dev libcurl4-openssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;
