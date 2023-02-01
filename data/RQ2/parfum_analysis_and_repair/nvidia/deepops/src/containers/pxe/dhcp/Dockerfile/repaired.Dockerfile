FROM ubuntu:16.04

MAINTAINER Douglas Holt <dholt@nvidia.com>

RUN apt-get update && \
    apt-get -y --no-install-recommends install dnsmasq && rm -rf /var/lib/apt/lists/*;

VOLUME /etc/dnsmasq.d

#ENTRYPOINT ["dnsmasq"]
CMD ["dnsmasq", "-d"]
