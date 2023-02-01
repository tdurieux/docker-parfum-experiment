FROM ubuntu:20.04

RUN apt-get update -qq && \
    apt-get install --no-install-recommends build-essential autoconf libtool-bin -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/fcml-lib

COPY . /usr/fcml-lib/
