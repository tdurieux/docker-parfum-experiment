FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc ca-certificates make libc6-dev gdb git patch wget xz-utils automake \
  autoconf \
  musl-tools && rm -rf /var/lib/apt/lists/*;
