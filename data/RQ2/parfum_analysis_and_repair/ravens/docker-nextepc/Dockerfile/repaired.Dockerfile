FROM ubuntu:18.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        libmicrohttpd-dev \
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
        pkg-config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install meson
RUN git clone https://github.com/open5gs/open5gs.git
WORKDIR /open5gs
RUN meson build && ninja -C build install
WORKDIR /

RUN apt-get -y --no-install-recommends install curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN cd /open5gs/webui && npm install && npm run build && npm cache clean --force;

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get --no-install-recommends -qy install tshark iptables net-tools && rm -rf /var/lib/apt/lists/*;

RUN apt-get --no-install-recommends -qy install mongodb-clients && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
