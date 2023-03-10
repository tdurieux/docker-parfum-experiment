FROM alpine:3.9

WORKDIR /go/src/github.com/newrelic/infrastructure-agent

RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache squid curl && \
        chown -R squid:squid /var/cache/squid && \
        chown -R squid:squid /var/log/squid && \
        squid -z

ADD test/proxy/squid-https-assets /

RUN chmod +x /start-squid.sh && \
        chmod +x /redirector.sh

EXPOSE 3129
ENTRYPOINT ["/start-squid.sh"]
