FROM golang:1.13-alpine

RUN apk add --no-cache git gcc musl-dev

COPY builder.sh /usr/bin/builder.sh

CMD ["/bin/sh", "/usr/bin/builder.sh"]