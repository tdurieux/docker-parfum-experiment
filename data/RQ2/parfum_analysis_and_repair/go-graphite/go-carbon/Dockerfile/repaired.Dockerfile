FROM golang:1.17.4-alpine3.15 AS build

ARG gocarbon_version=0.16.2
ARG gocarbon_repo=https://github.com/go-graphite/go-carbon.git
RUN apk add --no-cache --update git make bash \
 && git clone "${gocarbon_repo}" /usr/local/src/go-carbon \
 && cd /usr/local/src/go-carbon \
 && git checkout tags/v"${gocarbon_version}" \
 && make go-carbon \
 && chmod +x go-carbon && cp -fv go-carbon /tmp

FROM alpine:3.15

RUN addgroup -S carbon && adduser -S carbon -G carbon \
    && mkdir -p /var/lib/graphite/{whisper,dump,tagging} /var/log/go-carbon /etc/go-carbon/ \
    && chown -R carbon:carbon /var/lib/graphite/ /var/log/go-carbon

COPY --from=build /tmp/go-carbon /usr/sbin/go-carbon
ADD go-carbon.conf.example /etc/go-carbon/go-carbon.conf
ADD deploy/storage*.conf /etc/go-carbon/

USER carbon
CMD ["/usr/sbin/go-carbon", "-daemon=false", "-config", "/etc/go-carbon/go-carbon.conf"]

EXPOSE 2003 2004 7002 7003 7007 8080 2003/udp
VOLUME /var/lib/graphite /etc/go-carbon
