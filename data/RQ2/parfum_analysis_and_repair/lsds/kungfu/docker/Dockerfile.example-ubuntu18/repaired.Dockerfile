# A self contained example of how to setup minimal environment dependencies for KungFu
FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install --no-install-recommends -y curl wget git build-essential cmake python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir numpy==1.16 tensorflow==1.13.2

RUN wget -q https://dl.google.com/go/go1.13.linux-amd64.tar.gz \
    && tar -C /usr/local -xf go1.13.linux-amd64.tar.gz \
    && rm go1.13.linux-amd64.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

ADD . /KungFu
WORKDIR /KungFu

RUN pip3 install --no-cache-dir --no-index -U .
