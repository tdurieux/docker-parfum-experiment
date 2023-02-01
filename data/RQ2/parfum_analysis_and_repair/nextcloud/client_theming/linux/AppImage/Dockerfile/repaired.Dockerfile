FROM ubuntu:trusty

MAINTAINER Roeland Jago Douma <roeland@famdouma.nl>

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget libsqlite3-dev libssl-dev cmake git \
        software-properties-common build-essential mesa-common-dev fuse rsync && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:beineri/opt-qt58-trusty && \
    apt-get update && \
    apt-get install --no-install-recommends -y qt58base qt58tools && rm -rf /var/lib/apt/lists/*;

