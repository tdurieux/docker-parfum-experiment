FROM alpine:3.6

RUN apk add --no-cache --update bash curl bind-tools && \
    rm -rf /var/cache/apk/*

COPY waitdns.sh /
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
