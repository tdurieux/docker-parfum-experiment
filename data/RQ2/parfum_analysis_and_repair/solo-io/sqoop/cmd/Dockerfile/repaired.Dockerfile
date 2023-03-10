FROM alpine

RUN apk upgrade --update-cache \
    && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

COPY sqoop-linux-amd64 /usr/local/bin/sqoop

ENTRYPOINT ["/usr/local/bin/sqoop"]