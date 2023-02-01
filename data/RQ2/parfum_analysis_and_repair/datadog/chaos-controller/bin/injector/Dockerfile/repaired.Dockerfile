FROM ubuntu:focal as injector

RUN apt-get update && \
    apt-get -y --no-install-recommends install git gcc iproute2 coreutils python3 iptables && rm -rf /var/lib/apt/lists/*;

COPY injector /usr/local/bin/injector
COPY dns_disruption_resolver.py /usr/local/bin/dns_disruption_resolver.py

ENTRYPOINT ["/usr/local/bin/injector"]
