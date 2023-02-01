FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /hicn-build

COPY Makefile versions.cmake ./
COPY scripts scripts/

RUN apt update && apt-get install --no-install-recommends -y \
  make \
  sudo \
  curl \
  git && rm -rf /var/lib/apt/lists/*;

RUN make deps debug-tools

ENV DEBIAN_FRONTEND=
