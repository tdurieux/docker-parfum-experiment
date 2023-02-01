FROM alpine

RUN apk upgrade --update-cache \
    && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

COPY mesh-discovery-linux-amd64 /usr/local/bin/mesh-discovery

ENTRYPOINT ["/usr/local/bin/mesh-discovery"]