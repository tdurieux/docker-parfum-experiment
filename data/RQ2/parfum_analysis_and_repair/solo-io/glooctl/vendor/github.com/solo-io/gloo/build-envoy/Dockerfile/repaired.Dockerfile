FROM frolvlad/alpine-glibc

RUN apk upgrade --update-cache \
    && apk add --no-cache dumb-init \
&& rm -rf /var/cache/apk/*

COPY envoy /usr/local/bin/envoy
ENTRYPOINT /usr/local/bin/envoy