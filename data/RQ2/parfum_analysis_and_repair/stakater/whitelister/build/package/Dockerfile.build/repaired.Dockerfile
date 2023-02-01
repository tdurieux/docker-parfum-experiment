FROM golang:1.13.1-alpine
LABEL maintainer "Stakater Team"

RUN apk update

RUN apk -v --no-cache --update \
    add git build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir -p "$GOPATH/src/github.com/stakater/Whitelister"

ADD . "$GOPATH/src/github.com/stakater/Whitelister"

RUN cd "$GOPATH/src/github.com/stakater/Whitelister" && \
    go mod download && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a --installsuffix cgo --ldflags="-s" -o /Whitelister

COPY build/package/Dockerfile.run /

# Running this image produces a tarball suitable to be piped into another
# Docker build command.
CMD tar -cf - -C / Dockerfile.run Whitelister
