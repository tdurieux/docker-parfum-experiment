FROM alpine:3.4

# psql
RUN set -x \
      && apk add --no-cache --update bash jq curl postgresql alpine-sdk linux-headers \
      && rm -rf /var/cache/apk/*

COPY ./scripts/  /scripts

CMD ["/bin/true"]
