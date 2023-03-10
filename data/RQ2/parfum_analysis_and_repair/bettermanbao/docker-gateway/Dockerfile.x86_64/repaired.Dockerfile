FROM alpine:3.8

COPY init.sh /
RUN chmod +x /init.sh

RUN echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/01-ip_forward.conf

RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add iptables && \
    rm -rf /tmp/*
    
RUN mkdir /v2ray && \
    cd /v2ray && \
    wget https://github.com/v2ray/v2ray-core/releases/download/v4.11.0/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip && \
    rm config.json v2ray-linux-64.zip && \
    chmod +x v2ray v2ctl

COPY config.json /v2ray/

ENTRYPOINT ["/init.sh"]