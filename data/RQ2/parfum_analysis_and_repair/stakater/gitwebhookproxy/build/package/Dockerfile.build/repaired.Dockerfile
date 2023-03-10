FROM golang:1.13.1-alpine
MAINTAINER "Stakater Team"

RUN apk update

RUN apk -v --no-cache --update \
    add git build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir -p "$GOPATH/src/github.com/stakater/GitWebhookProxy"

ARG PACKR_VERSION=2.7.1
ARG PACKR_FILENAME=packr_${PACKR_VERSION}_linux_386.tar.gz
ARG PACKR_URL=https://github.com/gobuffalo/packr/releases/download/v${PACKR_VERSION}/${PACKR_FILENAME}

RUN mkdir -p /tmp/packr/ && \
    wget ${PACKR_URL} -O /tmp/packr/${PACKR_FILENAME} && \
    tar -xzvf /tmp/packr/${PACKR_FILENAME} -C /tmp/packr/ && \
    mv /tmp/packr/packr2 /usr/local/bin/packr2 && \
    rm -rf /tmp/packr

ADD . "$GOPATH/src/github.com/stakater/GitWebhookProxy"

RUN cd "$GOPATH/src/github.com/stakater/GitWebhookProxy" && \
    go mod download && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 packr2 build -a --installsuffix cgo --ldflags="-s" -o /GitWebhookProxy && \
    packr2 clean

COPY build/package/Dockerfile.run /

# Running this image produces a tarball suitable to be piped into another
# Docker build command.
CMD tar -cf - -C / Dockerfile.run GitWebhookProxy
