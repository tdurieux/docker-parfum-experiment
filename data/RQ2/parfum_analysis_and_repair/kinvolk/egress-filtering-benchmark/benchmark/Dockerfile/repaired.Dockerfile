FROM ubuntu:latest

MAINTAINER Imran Pochi <imran@kinvolk.io>

RUN apt-get update && \
    apt-get install --no-install-recommends -y iperf3 ipset iputils-ping && rm -rf /var/lib/apt/lists/*;

COPY benchmark /usr/bin/benchmark

ENTRYPOINT ["/usr/bin/benchmark"]

