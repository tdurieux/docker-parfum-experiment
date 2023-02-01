FROM ubuntu:xenial

MAINTAINER Aleksey Timin <atimin@gmail.com>

# Install dependencies
RUN apt-get update \
      && apt-get install --no-install-recommends -y libboost-all-dev cmake libssl-dev build-essential && rm -rf /var/lib/apt/lists/*;


# Prepare workdir
ADD / /OpcUaStack
WORKDIR /OpcUaStack

# Build
RUN sh build.sh -t local -i / -j 2 -B Release \
    && sh build.sh -t clean
