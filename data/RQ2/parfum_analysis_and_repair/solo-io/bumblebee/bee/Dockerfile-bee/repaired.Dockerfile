FROM alpine:3.14

# installs public root certs
RUN apk upgrade --update-cache \
    && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

ADD bee-linux-amd64 bee
