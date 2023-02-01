FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -q -y iproute2 curl dnsutils tcpdump iputils-ping net-tools telnet && rm -rf /var/lib/apt/lists/*;
