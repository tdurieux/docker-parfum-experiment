FROM alpine:latest

LABEL maintainer="AmneziaVPN"

ARG SS_RELEASE="v1.13.1"
ARG CLOAK_RELEASE="v2.5.5"
ARG SERVER_ARCH

#Install required packages
RUN apk add --no-cache curl openvpn easy-rsa bash netcat-openbsd dumb-init rng-tools
RUN apk --update upgrade --no-cache

ENV EASYRSA_BATCH 1
ENV PATH="/usr/share/easy-rsa:${PATH}"

RUN mkdir -p /opt/amnezia
RUN echo -e "#!/bin/bash\ntail -f /dev/null" > /opt/amnezia/start.sh
RUN chmod a+x /opt/amnezia/start.sh

RUN if [ $SERVER_ARCH="x86_64" ]; then CK_ARCH="amd64"; \
    elif [ $SERVER_ARCH="i686" ]; then CK_ARCH="386"; \
    elif [ $SERVER_ARCH="aarch64" ]; then CK_ARCH="arm64"; \
    elif [ $SERVER_ARCH="arm" ]; then CK_ARCH="arm"; \
    else exit -1; fi && \
    curl -L https://github.com/cbeuw/Cloak/releases/download/${CLOAK_RELEASE}/ck-server-linux-${CK_ARCH}-${CLOAK_RELEASE} > /usr/bin/ck-server
RUN chmod a+x /usr/bin/ck-server

RUN curl -L https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SS_RELEASE}/shadowsocks-${SS_RELEASE}.${SERVER_ARCH}-unknown-linux-musl.tar.xz  > /usr/bin/ss.tar.xz

RUN tar -Jxvf /usr/bin/ss.tar.xz -C /usr/bin/
RUN chmod a+x /usr/bin/ssserver

# Tune network  
RUN echo -e " \n\
  fs.file-max = 51200 \n\
  \n\
  net.core.rmem_max = 67108864 \n\
  net.core.wmem_max = 67108864 \n\
  net.core.netdev_max_backlog = 250000 \n\
  net.core.somaxconn = 4096 \n\
  \n\
  net.ipv4.tcp_syncookies = 1 \n\
  net.ipv4.tcp_tw_reuse = 1 \n\
  net.ipv4.tcp_tw_recycle = 0 \n\
  net.ipv4.tcp_fin_timeout = 30 \n\
  net.ipv4.tcp_keepalive_time = 1200 \n\
  net.ipv4.ip_local_port_range = 10000 65000 \n\
  net.ipv4.tcp_max_syn_backlog = 8192 \n\
  net.ipv4.tcp_max_tw_buckets = 5000 \n\
  net.ipv4.tcp_fastopen = 3 \n\
  net.ipv4.tcp_mem = 25600 51200 102400 \n\
  net.ipv4.tcp_rmem = 4096 87380 67108864 \n\
  net.ipv4.tcp_wmem = 4096 65536 67108864 \n\
  net.ipv4.tcp_mtu_probing = 1 \n\
  net.ipv4.tcp_congestion_control = hybla \n\
  # for low-latency network, use cubic instead \n\
  # net.ipv4.tcp_congestion_control = cubic \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/sysctl.conf && \
  mkdir -p /etc/security && \
  echo -e " \n\
  * soft nofile 51200 \n\
  * hard nofile 51200 \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/security/limits.conf  

ENTRYPOINT [ "dumb-init", "/opt/amnezia/start.sh" ]
CMD [ "" ]
