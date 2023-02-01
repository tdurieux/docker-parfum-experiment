FROM centos:8

USER root

# Enable bbr
RUN yum install git vim wget -y && rm -rf /var/cache/yum
RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install gcc \
    gettext autoconf libtool automake make pcre-devel \
    asciidoc xmlto c-ares-devel libev-devel libsodium-devel \
    mbedtls-devel -y && rm -rf /var/cache/yum

# install shaodowsocks-libev
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git submodule update --init --recursive \
    && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install

RUN mkdir -p /etc/shadowsocks-libev

# simple-obfs
RUN yum install zlib-devel openssl-devel -y && rm -rf /var/cache/yum
RUN git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs && git submodule update --init --recursive \
    && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# VOLUME /etc/shadowsocks-libev

RUN mkdir -p /etc/shadowsocks-libev
ADD config.json /etc/shadowsocks-libev/config.json

# ADD shadowsocks.service /etc/systemd/system/shadowsocks.service

# USER nobody

ENTRYPOINT ["/usr/bin/ss-server", "-c", "/etc/shadowsocks-libev/config.json", "-u"]
