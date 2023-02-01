FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install git build-essential zlib1g-dev python3 \
    liblzma-dev python-magic bsdmainutils python3-pip && rm -rf /var/lib/apt/lists/*;

RUN git clone --depth 1 https://github.com/rampageX/firmware-mod-kit
