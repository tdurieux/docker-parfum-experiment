FROM alpine:3

RUN apk add --no-cache curl

COPY drain-watch.sh /bin/drain-watch.sh

ENTRYPOINT ["/bin/drain-watch.sh"]