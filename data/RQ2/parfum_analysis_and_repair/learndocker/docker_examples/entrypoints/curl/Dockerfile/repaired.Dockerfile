FROM alpine:3.6

RUN apk update \
      && apk add --no-cache curl \
      && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/curl"]
CMD ["--help"]
