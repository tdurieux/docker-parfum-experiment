FROM golang:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y libpcap-dev && \
    wget https://launchpadlibrarian.net/234454186/librdkafka1_0.8.6-1.1_amd64.deb && \
    wget https://launchpadlibrarian.net/234454185/librdkafka-dev_0.8.6-1.1_amd64.deb && \
    dpkg -i librdkafka1_0.8.6-1.1_amd64.deb && \
    dpkg -i librdkafka-dev_0.8.6-1.1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /go/src/github.com/trivago/gollum