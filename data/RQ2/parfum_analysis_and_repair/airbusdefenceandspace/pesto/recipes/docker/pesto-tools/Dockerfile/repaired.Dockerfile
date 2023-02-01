FROM ubuntu:18.04

ARG DOCKERDIR

RUN apt update && apt install --no-install-recommends -y \
    build-essential python3-pip twine git && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y \
    docker.io nano && rm -rf /var/lib/apt/lists/*;

ADD . /tmp

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN cd tmp && make all
