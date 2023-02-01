FROM ubuntu:xenial

MAINTAINER ZetaVM Developers

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc \
    g++ \
    make \
    clang && rm -rf /var/lib/apt/lists/*;

COPY ./ ./
