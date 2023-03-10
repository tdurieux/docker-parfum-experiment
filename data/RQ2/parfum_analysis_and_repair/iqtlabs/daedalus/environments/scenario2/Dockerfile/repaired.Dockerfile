FROM ubuntu:20.04
MAINTAINER Charlie Lewis <clewis@iqt.org>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libmicrohttpd-dev \
        libnghttp2-dev \
        libcurl4-gnutls-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        build-essential \
        flex \
        bison \
        git \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libidn11-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        iproute2 \
        ca-certificates \
        netbase \
        tshark \
        iptables \
        net-tools \
        mongodb-clients \
        curl \
        gnupg \
        pkg-config \
        tcpdump \
        iputils-ping \
        lksctp-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install meson
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/open5gs/open5gs.git -b v2.2.9
WORKDIR /open5gs
RUN meson build && ninja -C build install
RUN ldconfig
WORKDIR /open5gs/webui
RUN npm install && npm run build && npm cache clean --force;
RUN ln -s /usr/local/lib/*/freeDiameter /freeDiameter

ENTRYPOINT ["/bin/sh"]
