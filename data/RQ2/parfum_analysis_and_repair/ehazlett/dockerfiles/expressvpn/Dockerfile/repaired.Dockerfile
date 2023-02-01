FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://download.expressvpn.xyz/clients/linux/expressvpn_1.2.0_amd64.deb -o /tmp/expressvpn.deb && \
    dpkg -i /tmp/expressvpn.deb && \
    apt-get -f -y install && \
    rm -rf /tmp/expressvpn.deb
