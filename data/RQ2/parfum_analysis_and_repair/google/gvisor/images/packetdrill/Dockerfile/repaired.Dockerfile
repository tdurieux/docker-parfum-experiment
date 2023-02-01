FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y net-tools git iptables iputils-ping \
        netcat tcpdump jq tar bison flex make && rm -rf /var/lib/apt/lists/*;
# Pick up updated git.
RUN hash -r
RUN git clone --depth 1 --branch packetdrill-v2.0 \
        https://github.com/google/packetdrill.git
RUN cd packetdrill/gtests/net/packetdrill && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
