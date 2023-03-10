FROM golang:1.8-alpine

RUN apk add --no-cache make

ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# The project sources
VOLUME ["/go/src/github.com/rneugeba/iso9660wrap"]
WORKDIR /go/src/github.com/rneugeba/iso9660wrap

ENTRYPOINT ["make"]