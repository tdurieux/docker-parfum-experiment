FROM alpine:3.11.6

# installs public root certs
# needed to establish trust with third party sources
RUN apk upgrade --update-cache \
    && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

COPY gloo-mesh-linux-amd64 /usr/local/bin/gloo-mesh

USER 10101

ENTRYPOINT ["/usr/local/bin/gloo-mesh"]
