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
ENV CI=true

RUN $AG update && $AG install ash iptables sudo openvswitch-switch openvswitch-common \
    python3 python3-pip python3.8 python3.8-venv python3.8-dev build-essential python3-yaml

RUN update-alternatives --install /usr/bin/python3 python /usr/bin/python3.8 2

RUN python3 -m pip install grpcio
RUN python3 -m pip install grpcio-tools

# Start OVS