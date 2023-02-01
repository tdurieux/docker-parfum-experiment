##################################
# STEP 1 build executable binary
##################################
FROM alpine:latest AS builder

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"
LABEL github="https://github.com/lordbasex/docker/docker-asterisk-fastagi-go"

ENV GO111MODULE=on \
    GOPATH=/home/go \
    PATH=/home/go/bin:$PATH \
    GOBIN=/home/go/bin

RUN apk update && apk add --no-cache --update-cache git go bash ca-certificates
RUN mkdir -p /home/go/src /home/go/bin /home/go/src/fastagi && chmod -R 777 /home/go /home/go/src/fastagi && cp -fr /usr/bin/go /home/go/bin/
WORKDIR /home/go/src/fastagi
COPY ./fastagi.go .
RUN go mod init fastagi
RUN go get -v
RUN go build -o /go/bin/fastagi

##################################
# STEP 2 build a small image
##################################
FROM alpine:latest

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"
LABEL github="https://github.com/lordbasex/docker/docker-asterisk-fastagi-go"

RUN apk update && apk add --no-cache --update-cache bash

COPY --from=builder /go/bin/fastagi /go/bin/fastagi
COPY ./audios /audios

ENV FASTAGI_PORT=8000 \
    SERVER_MEDIA="http://fastagi:8011/" \
    SERVER_MEDIA_DIR="/audios"

ENTRYPOINT ["/go/bin/fastagi"]
