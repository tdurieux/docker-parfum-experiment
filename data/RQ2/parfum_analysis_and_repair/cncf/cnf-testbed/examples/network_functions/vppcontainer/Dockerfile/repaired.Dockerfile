FROM ubuntu:18.04

ENV VPP_VER "20.01"

RUN apt-get update && apt-get --no-install-recommends install -y \
    gnupg \
    apt-transport-https \
    curl \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash

RUN apt-get --no-install-recommends install -y \
    dpdk \
    vpp=${VPP_VER}-release \
    vpp-plugin-core=${VPP_VER}-release \
    vpp-plugin-dpdk=${VPP_VER}-release \
    libvppinfra=${VPP_VER}-release && rm -rf /var/lib/apt/lists/*;

CMD ["/usr/bin/vpp", "-c", "/etc/vpp/startup.conf"]
