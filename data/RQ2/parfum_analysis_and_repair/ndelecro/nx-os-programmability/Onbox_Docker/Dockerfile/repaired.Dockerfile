FROM ubuntu
MAINTAINER Nicolas Delecroix <ndelecro@cisco.com>

RUN apt-get -y update && \
        apt-get -y --no-install-recommends install iproute2 iputils-ping emacs subversion && rm -rf /var/lib/apt/lists/*;

# Packet Generator
RUN apt-get -y --no-install-recommends install python3-scapy && \
        mkdir /root/Packet_Generator && \
        svn checkout --trust-server-cert --non-interactive "https://github.com/ndelecro/nx-os-programmability/trunk/Onbox_Docker/Packet_Generator" /root/Packet_Generator && rm -rf /var/lib/apt/lists/*;

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
