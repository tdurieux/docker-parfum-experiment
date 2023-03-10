FROM alpine:3.8

RUN apk add --update --no-cache ca-certificates

RUN addgroup -g 1000 -S test && \
adduser -u 1000 -S test -G test

COPY entrypoint.sh /usr/local/bin/

USER test

ENTRYPOINT ["entrypoint.sh"]