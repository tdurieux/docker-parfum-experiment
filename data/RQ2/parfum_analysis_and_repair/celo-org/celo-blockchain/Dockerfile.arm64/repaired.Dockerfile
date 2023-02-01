# celohq/android-client

FROM circleci/rust:1.41.0-buster

USER root

RUN apt update && \
    apt-get install -y --no-install-recommends gcc-aarch64-linux-gnu && \
    rm -rf /var/lib/apt/lists/*

RUN rustup target add aarch64-unknown-linux-gnu
RUN wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz && \
    tar xf go1.16.4.linux-amd64.tar.gz -C /usr/local && rm go1.16.4.linux-amd64.tar.gz

COPY . /go-ethereum
WORKDIR /go-ethereum

ENV PATH $PATH:/usr/local/go/bin

CMD /bin/bash
