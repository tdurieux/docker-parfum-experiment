FROM golang:1.12.5-alpine3.9 as builder

ADD . $GOPATH/src/github.com/improbable-eng/thanos
WORKDIR $GOPATH/src/github.com/improbable-eng/thanos

RUN apk update && apk upgrade && apk add --no-cache alpine-sdk

RUN git update-index --refresh; make build

# -----------------------------------------------------------------------------

FROM quay.io/prometheus/busybox:latest
LABEL maintainer="The Thanos Authors"

COPY --from=builder /go/src/github.com/improbable-eng/thanos/thanos /bin/thanos

ENTRYPOINT [ "/bin/thanos" ]
