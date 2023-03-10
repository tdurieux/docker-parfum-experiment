FROM golang:1.10-alpine3.8 AS builder
WORKDIR $GOPATH/src/github.com/nats-io/nats-operator/
RUN apk add --no-cache --update git
RUN go get -u github.com/golang/dep/cmd/dep
COPY . .
RUN dep ensure -v -vendor-only
RUN CGO_ENABLED=0 go build -ldflags "-X github.com/nats-io/nats-operator/version.GitSHA=`git rev-parse --short HEAD`" -installsuffix cgo -o /nats-server-config-reloader ./cmd/reloader/main.go

FROM alpine:3.8
COPY --from=builder /nats-server-config-reloader /usr/local/bin/nats-server-config-reloader
CMD ["nats-server-config-reloader"]
