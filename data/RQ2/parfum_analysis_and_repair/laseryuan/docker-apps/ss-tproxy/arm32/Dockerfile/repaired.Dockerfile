# Redsocks docker image.
FROM debian:buster-20200327

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get install --no-install-recommends -y \
      iptables curl perl ipset iproute2 dnsmasq make gcc libuv1-dev automake libtool unzip && rm -rf /var/lib/apt/lists/*;

# https://forums.balena.io/t/unable-to-complete-the-sense-application-help-please/19698/6
RUN c_rehash

# Installation of chinadns-ng
RUN curl -f -L https://github.com/zfl9/chinadns-ng/archive/master.zip -o /tmp/chinadns-ng.zip
RUN unzip /tmp/chinadns-ng.zip -d /tmp/
RUN mv /tmp/chinadns-ng-master /tmp/chinadns-ng

WORKDIR /tmp/chinadns-ng
RUN make && make install

# Install libuv
ENV libuv_version="1.32.0"
RUN curl -f -L https://github.com/libuv/libuv/archive/v$libuv_version.tar.gz -o /tmp/libuv-$libuv_version.tar.gz && \
  tar xvf /tmp/libuv-$libuv_version.tar.gz -C /tmp/ && \
  mv /tmp/libuv-$libuv_version /tmp/libuv && rm /tmp/libuv-$libuv_version.tar.gz

WORKDIR /tmp/libuv
RUN ./autogen.sh && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/libuv --enable-shared=no --enable-static=yes CC="gcc -O3" && \
  make && make install

# Installation of ipt2socks
ENV ipt2socks_version="1.0.2"
RUN curl -f -L https://github.com/zfl9/ipt2socks/archive/v$ipt2socks_version.tar.gz -o /tmp/ipt2socks.tar.gz && \
  tar xvf /tmp/ipt2socks.tar.gz -C /tmp/ && \
  mv /tmp/ipt2socks-$ipt2socks_version /opt/ipt2socks && rm /tmp/ipt2socks.tar.gz

WORKDIR /opt/ipt2socks
RUN make INCLUDES="-I/opt/libuv/include" LDFLAGS="-L/opt/libuv/lib" && make install

# Installation of dns2tcp
ENV dns2tcp_version="master"
RUN curl -f -L https://github.com/zfl9/dns2tcp/archive/${dns2tcp_version}.zip -o /tmp/dns2tcp.zip && \
  unzip /tmp/dns2tcp.zip -d /tmp/ && \
  mv /tmp/dns2tcp-${dns2tcp_version} /tmp/dns2tcp

WORKDIR /tmp/dns2tcp
RUN make && make install

# Build ss-tproxy
ENV sstproxy_version="4.6"
RUN curl -f -L https://github.com/zfl9/ss-tproxy/archive/v${sstproxy_version}.tar.gz -o /tmp/sstproxy.tar.gz && \
  tar xvf /tmp/sstproxy.tar.gz -C /tmp/ && \
  mv /tmp/ss-tproxy-${sstproxy_version} /tmp/ss-tproxy && rm /tmp/sstproxy.tar.gz

WORKDIR /tmp/ss-tproxy
RUN chmod +x ss-tproxy && \
  cp -af ss-tproxy /usr/local/bin && \
  mkdir -p /etc/ss-tproxy && \
  cp -af ss-tproxy.conf gfwlist* chnroute* ignlist* /etc/ss-tproxy && \
  cp -af ss-tproxy.service /etc/systemd/system

# Installation of redsocks2
RUN apt-get install --no-install-recommends -y \
      git libevent-dev openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

ENV redsocks2_version="master"
RUN curl -f -L https://github.com/semigodking/redsocks/archive/${redsocks2_version}.zip -o /tmp/redsocks2.zip && \
  unzip /tmp/redsocks2.zip -d /tmp/ && \
  mv /tmp/redsocks-${redsocks2_version} /tmp/redsocks2

WORKDIR /tmp/redsocks2
RUN make DISABLE_SHADOWSOCKS=true && \
  mv redsocks2 /usr/local/bin

# Development
# RUN apt-get install -y \
      # python netcat dnsutils procps

# https://github.com/moby/moby/issues/38099
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

COPY tmpl/ /etc/ss-tproxy/tmpl/
COPY docker-entrypoint.sh /
COPY README.md /

ENTRYPOINT ["/docker-entrypoint.sh"]
