# Build time
FROM ubuntu:groovy as build

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

RUN apt-get -y --no-install-recommends install g++ libssl-dev libz-dev make python ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;

COPY . /opt
WORKDIR /opt

#
# To use the container interactively for debugging/building
# 1. Build with
#    CMD ["ls"]
# 2. Run with
#    docker run --entrypoint sh -it docker-game-eng-dev.addsrv.com/ws:9.10.6
#

RUN ["make", "test"]
# CMD ["ls"]
