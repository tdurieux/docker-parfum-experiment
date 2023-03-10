# This file was inspired by envoy Dockerfile:
# https://github.com/envoyproxy/envoy/blob/445a67344ffda0c8828c8e438e463fcaa7878434/ci/Dockerfile-envoy-alpine

# From Source: https://github.com/CelsoSantos/alpine-glibc
FROM celsosantos/alpine-glibc:arm64

ENV loglevel=info

RUN apk upgrade --update-cache \
  && apk add --no-cache dumb-init \
  && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/envoy

ADD envoy.stripped /usr/local/bin/envoy

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/envoy"]
CMD ["--v2-config-only", "-c", "/etc/envoy/envoy.yaml"]
