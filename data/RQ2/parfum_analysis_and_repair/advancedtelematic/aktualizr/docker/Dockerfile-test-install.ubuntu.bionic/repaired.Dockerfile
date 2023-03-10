FROM ubuntu:bionic
LABEL Description="Ubuntu Bionic package testing dockerfile"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install debian-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
  libarchive13 \
  libboost-log1.65.1 \
  libboost-program-options1.65.1 \
  libboost-system1.65.1 \
  libboost-test1.65.1 \
  libboost-thread1.65.1 \
  libc6 \
  libcurl4 \
  libglib2.0-0 \
  libsodium23 \
  libsqlite3-0 \
  libssl1.1 \
  libstdc++6 \
  lshw \
  openjdk-8-jre \
  python3 \
  zip && rm -rf /var/lib/apt/lists/*;

ADD ./scripts /scripts
