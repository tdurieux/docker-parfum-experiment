FROM golang:1.16-alpine AS builder
COPY . /go/src/github.com/tsuru/rpaas-operator
WORKDIR /go/src/github.com/tsuru/rpaas-operator
RUN apk add --no-cache --update gcc git make musl-dev && \
    make build-api

FROM alpine:3.8
COPY --from=builder /go/src/github.com/tsuru/rpaas-operator/rpaas-api /bin/rpaas-api
RUN apk update && \
    apk add --no-cache ca-certificates && \
    rm /var/cache/apk/*
EXPOSE 9999
CMD ["/bin/rpaas-api"]
