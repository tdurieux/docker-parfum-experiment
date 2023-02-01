FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y \
  git libseccomp-dev build-essential libsqlite3-dev \
  pkg-config libssl-dev libclang-dev clang libz3-dev \
  python2 python ninja-build libfontconfig1-dev curl && rm -rf /var/lib/apt/lists/*;

COPY ./prepare.sh /
RUN /prepare.sh

COPY ./entrypoint.sh /

ENTRYPOINT /entrypoint.sh
