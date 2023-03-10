FROM ubuntu:18.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    inetutils-traceroute \
    ca-certificates \
    libmbedcrypto1 \
    libmbedtls10 \
    libmbedx509-0 \
    libnuma1 \
    sudo \
    iputils-ping \
    net-tools \
    iproute2 \
    tcpdump \
    python3-cffi \
    python2.7 \
    libssl-dev \
    netcat; \
    rm -rf /var/lib/apt/lists/*; \
    mv /usr/sbin/tcpdump /usr/bin/tcpdump

WORKDIR /tmp

COPY startup.conf /etc/startup.conf

COPY vpp-package.tgz /tmp

RUN set -eux; \
    tar xzf vpp-package.tgz; rm vpp-package.tgz \
    dpkg -i *.deb ; \
    rm -rf *.deb

WORKDIR /

CMD vpp -c /etc/startup.conf

