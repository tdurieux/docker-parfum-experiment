FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc ca-certificates make libc6-dev \
  gcc-mingw-w64-x86-64 libz-mingw-w64-dev && rm -rf /var/lib/apt/lists/*;
