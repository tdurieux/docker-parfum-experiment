FROM ubuntu:18.04
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc \
  libc6-dev \
  ca-certificates \
  musl-tools && rm -rf /var/lib/apt/lists/*;
