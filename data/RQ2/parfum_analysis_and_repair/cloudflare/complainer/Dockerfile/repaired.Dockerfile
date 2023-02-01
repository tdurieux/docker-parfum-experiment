FROM alpine:3.4

COPY . /go/src/github.com/cloudflare/complainer

RUN apk --update --no-cache add go ca-certificates && \
    export GOPATH=/go GO15VENDOREXPERIMENT=1 && \
    go get github.com/cloudflare/complainer/... && \
    apk del go

USER nobody

ENTRYPOINT ["/go/bin/complainer"]
