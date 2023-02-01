FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc ca-certificates make xz-utils libc6-dev gdb curl && rm -rf /var/lib/apt/lists/*;
