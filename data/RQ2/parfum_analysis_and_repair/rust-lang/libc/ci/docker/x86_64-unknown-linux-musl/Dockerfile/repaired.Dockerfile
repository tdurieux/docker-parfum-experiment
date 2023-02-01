FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc make libc6-dev git curl ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY install-musl.sh /
RUN sh /install-musl.sh x86_64

ENV PATH=$PATH:/musl-x86_64/bin:/rust/bin
