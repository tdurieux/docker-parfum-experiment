FROM alpine:3.15.4

ARG GOARCH=amd64

# Needed for access to AWS
RUN apk upgrade --update-cache \
    && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

COPY discovery-linux-$GOARCH /usr/local/bin/discovery

USER 10101

ENTRYPOINT ["/usr/local/bin/discovery"]