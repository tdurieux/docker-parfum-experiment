## Image name: daqf/daq

FROM ubuntu:focal

WORKDIR /root

COPY bin/retry_cmd bin/

ENV AG="bin/retry_cmd apt-get -qqy --no-install-recommends -o=Dpkg::Use-Pty=0"

RUN $AG update && $AG install net-tools bash iproute2 iputils-ping tcpdump strace vim \
    jq nano ethtool netcat curl ifupdown isc-dhcp-client dnsmasq arp-scan

# Weird workaround for problem running tcdump in a privlidged container.
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Fake build running on CI while to avoid using venv during DAQ install.