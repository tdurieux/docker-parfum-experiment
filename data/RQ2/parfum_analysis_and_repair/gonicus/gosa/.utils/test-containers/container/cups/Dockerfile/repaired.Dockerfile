FROM debian:latest
MAINTAINER Cajus Pollmeier <pollmeier@gonicus.de>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo whois cups cups-client cups-bsd printer-driver-all hpijs-ppds \
    hp-ppd hplip && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/sbin/cupsd", "-f"]
