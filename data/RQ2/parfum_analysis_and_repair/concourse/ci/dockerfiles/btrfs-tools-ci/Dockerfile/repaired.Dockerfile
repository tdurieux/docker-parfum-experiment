FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install liblzo2-dev libblkid-dev e2fslibs-dev pkg-config libz-dev curl && rm -rf /var/lib/apt/lists/*;
