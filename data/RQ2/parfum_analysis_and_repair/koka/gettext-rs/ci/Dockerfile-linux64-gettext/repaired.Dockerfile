FROM ubuntu:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc xz-utils ca-certificates make libc6-dev gdb curl \
  gettext && rm -rf /var/lib/apt/lists/*;
