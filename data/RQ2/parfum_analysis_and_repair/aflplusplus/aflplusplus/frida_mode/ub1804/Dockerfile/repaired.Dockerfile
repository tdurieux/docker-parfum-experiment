FROM ubuntu:xenial

WORKDIR /AFLplusplus

RUN apt-get update && apt-get install --no-install-recommends -y make gcc g++ xz-utils curl wget clang zlib1g-dev && rm -rf /var/lib/apt/lists/*;