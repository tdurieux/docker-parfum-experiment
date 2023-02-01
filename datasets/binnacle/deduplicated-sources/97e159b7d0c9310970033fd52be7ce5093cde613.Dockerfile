FROM arm32v6/alpine as builder

RUN apk add --no-cache bash git build-base go \
	musl-dev openssl jq curl bind-tools whois \
	dnscrypt-proxy autoconf automake \
	ca-certificates \
	&& update-ca-certificates

RUN cd /root && git clone https://github.com/jech/polipo && cd polipo && make

RUN GOPATH=/go go get -u v2ray.com/core/...
RUN GOPATH=/go go build -o /usr/bin/v2ray/v2ray v2ray.com/core/main
RUN GOPATH=/go go build -o /usr/bin/v2ray/v2ctl v2ray.com/core/infra/control/main
RUN cp -r /go/src/v2ray.com/core/release/config/* /usr/bin/v2ray/


FROM arm32v6/alpine

RUN apk update
RUN apk upgrade
RUN apk add bash openssl jq curl bind-tools whois dnscrypt-proxy ca-certificates && update-ca-certificates
RUN rm -rf /var/cache/apk/*

RUN mkdir /etc/v2ray/
RUN mkdir /var/log/v2ray/
RUN mkdir -p /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray  /usr/bin/v2ray
COPY --from=builder /root/polipo /root/polipo
ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENV LSTNADDR="0.0.0.0"
ENV SOCKSPORT="1080"
ENV HTTPPORT="8123"
ENV DNSPORT="53"

RUN sed -i "s/^listen_addresses = .*/listen_addresses = \[\'0.0.0.0:$DNSPORT\'\]/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^dnscrypt_servers = .*/dnscrypt_servers = false/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s/^doh_servers = .*/doh_servers = true/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

RUN echo "socksParentProxy=localhost:$SOCKSPORT" >>/root/polipo/config
RUN echo "proxyAddress=$LSTNADDR" >>/root/polipo/config
RUN echo "proxyPort=$HTTPPORT" >>/root/polipo/config
RUN echo "daemonise=true" >>/root/polipo/config
RUN echo "diskCacheRoot=" >>/root/polipo/config

ENTRYPOINT ["/run.sh"]
