# This is the Dockerfile used for release (published to dockerhub by goreleaser)

# See .ldrelease/config.yml for an explanation of the build/release process.

FROM alpine:3.16.0
# See "Runtime platform versions" in CONTRIBUTING.md

RUN apk add --no-cache \
    ca-certificates \
 && apk add --no-cache --upgrade libcrypto1.1 libssl1.1 \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

COPY ld-relay /usr/bin/ldr

RUN addgroup -g 1000 -S ldr-user && \
    adduser -u 1000 -S ldr-user -G ldr-user && \
    mkdir /ldr && \
    chown 1000:1000 /ldr

USER 1000

EXPOSE 8030
ENV PORT=8030
ENTRYPOINT ["/usr/bin/ldr", "--config", "/ldr/ld-relay.conf", "--allow-missing-file", "--from-env"]
