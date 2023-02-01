ARG src_uri=github.com/cloudflare/gortr/cmd/rtrdump

FROM golang:alpine as builder
ARG src_uri

RUN apk --update --no-cache add git && \
    go get -u $src_uri

FROM alpine:latest
ARG src_uri

RUN apk --update --no-cache add ca-certificates && \
    adduser -S -D -H -h / rtr
USER rtr

COPY --from=builder /go/bin/rtrdump /
ENTRYPOINT ["./rtrdump"]
