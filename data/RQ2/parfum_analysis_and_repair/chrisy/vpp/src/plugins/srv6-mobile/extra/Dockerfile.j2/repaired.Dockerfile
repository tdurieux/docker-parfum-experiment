FROM ubuntu:18.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    inetutils-traceroute \
    ca-certificates \
    build-essential \
    git gdb sudo \
    iputils-ping \
    net-tools \
    iproute2 \
    tcpdump \
    python3-cffi \
    asciidoc \
    xmlto \
    libssl-dev \
    netcat; \
    rm -rf /var/lib/apt/lists/*; \
    mv /usr/sbin/tcpdump /usr/bin/tcpdump

RUN set -eux; \
    mkdir -p {{vpp_path}}

COPY . / {{vpp_path}}/

WORKDIR {{vpp_path}}

RUN set -eux; \
    make wipe; \
    export UNATTENDED=y; \
    echo "y" | make install-dep; \
    rm -rf /var/lib/apt/lists/* ; \
    make build; \
    make pkg-deb; \
    rm -rf .ccache; \
    find . -type f -name '*.o' -delete ; \
    cd {{vpp_path}}/build-root; \
    rm vpp-api-python_*.deb; \
    tar czf vpp-package.tgz *.deb; \
    mv vpp-package.tgz {{vpp_path}}/; \
    dpkg -i *.deb ; \
    cp {{vpp_path}}/startup.conf /etc/startup.conf

WORKDIR /
 
CMD vpp -c /etc/startup.conf