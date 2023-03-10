ARG src_uri=github.com/cloudflare/cfrpki/cmd/octorpki

FROM golang:alpine as builder
ARG src_uri

RUN apk --update --no-cache add git && \
    go get -u $src_uri

FROM alpine:latest
ARG src_uri

RUN apk --update --no-cache add ca-certificates rsync && \
    adduser -S -D -H -h / rpki && \
    mkdir /cache && chmod 770 /cache && chown rpki:root /cache && \
    touch rrdp.json && chown rpki rrdp.json
USER rpki

COPY --from=builder /go/bin/octorpki /
COPY cmd/octorpki/private.pem /
COPY cmd/octorpki/tals /tals

VOLUME ["/cache"]

ENTRYPOINT ["./octorpki"]