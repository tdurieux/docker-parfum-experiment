FROM golang:alpine

RUN \
  apk add --no-cache --update git make gcc musl-dev linux-headers

CMD ["echo","hello world"]

