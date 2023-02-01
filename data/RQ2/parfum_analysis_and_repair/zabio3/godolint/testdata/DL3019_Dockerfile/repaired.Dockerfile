FROM alpine:3.7
RUN apk update \
    && apk add --no-cache foo=1.0 \
    && rm -rf /var/cache/apk/*