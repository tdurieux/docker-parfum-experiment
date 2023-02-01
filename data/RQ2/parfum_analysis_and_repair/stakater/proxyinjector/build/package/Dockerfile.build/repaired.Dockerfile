FROM golang:1.13.1-alpine
MAINTAINER "Stakater Team"

RUN apk update

RUN apk -v --no-cache --update \
    add git build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir -p "$GOPATH/src/github.com/stakater/ProxyInjector"

ADD . "$GOPATH/src/github.com/stakater/ProxyInjector"

RUN cd "$GOPATH/src/github.com/stakater/ProxyInjector" && \
    go mod download

RUN cd "$GOPATH/src/github.com/stakater/ProxyInjector" && \
     CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a --installsuffix cgo --ldflags="-s" -o /ProxyInjector

COPY build/package/Dockerfile.run /

# Running this image produces a tarball suitable to be piped into another
# Docker build command.
CMD tar -cf - -C / Dockerfile.run ProxyInjector
