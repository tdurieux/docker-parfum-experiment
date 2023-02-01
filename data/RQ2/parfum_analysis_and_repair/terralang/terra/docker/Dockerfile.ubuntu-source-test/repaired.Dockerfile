ARG release=18.04

FROM ubuntu:$release

ENV DEBIAN_FRONTEND noninteractive
ENV CI 1 # skip CUDA tests

COPY . /terra_install

RUN cat /etc/lsb-release && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq build-essential && \
    cd /terra_install/share/terra/tests && \
    /terra_install/bin/terra ./run && rm -rf /var/lib/apt/lists/*;
