FROM alpine:3.12.4 as builder

RUN apk add --no-cache --update alpine-sdk bsd-compat-headers \
 && git clone https://github.com/Kexkey/proxychains-ng.git

RUN cd /proxychains-ng \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install \
 && make install-config

FROM node:15.11.0-alpine3.12

RUN apk add --update --no-cache \
    jq \
    su-exec \
 && npm install -g opentimestamps && npm cache clean --force;

WORKDIR /script

COPY --from=builder /usr/local/etc/proxychains.conf /usr/local/etc/proxychains.conf
COPY --from=builder /usr/local/bin/proxychains4 /usr/local/bin/proxychains4
COPY --from=builder /usr/local/lib/libproxychains4.so /usr/local/lib/libproxychains4.so

COPY script/otsclient.sh /script/otsclient.sh
COPY script/requesthandler.sh /script/requesthandler.sh
COPY script/responsetoclient.sh /script/responsetoclient.sh
COPY script/startotsclient.sh /script/startotsclient.sh
COPY script/trace.sh /script/trace.sh

RUN chmod +x /script/startotsclient.sh /script/requesthandler.sh

ENTRYPOINT ["su-exec"]
