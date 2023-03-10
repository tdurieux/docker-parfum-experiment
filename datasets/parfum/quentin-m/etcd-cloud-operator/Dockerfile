#Min version required
#See: https://github.com/golang/go/issues/29278#issuecomment-447537558
FROM golang:1.16-alpine3.12 AS build-env

WORKDIR /go/src/github.com/quentin-m/etcd-cloud-operator

# Install & cache dependencies
RUN apk add --no-cache git curl gcc musl-dev ca-certificates openssl wget
RUN update-ca-certificates

RUN wget https://github.com/etcd-io/etcd/releases/download/v3.5.0-alpha.0/etcd-v3.5.0-alpha.0-linux-amd64.tar.gz -O /tmp/etcd.tar.gz && \
    mkdir /etcd && \
    tar xzvf /tmp/etcd.tar.gz -C /etcd --strip-components=1 && \
    rm /tmp/etcd.tar.gz

# Force the go compiler to use modules
ENV GO111MODULE=on

# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN go mod download

FROM build-env as builder
COPY . .
RUN go install github.com/quentin-m/etcd-cloud-operator/cmd/operator
RUN go install github.com/quentin-m/etcd-cloud-operator/cmd/tester

# Copy ECO and etcdctl into an Alpine Linux container image.
FROM alpine

RUN apk add --no-cache ca-certificates docker-cli
RUN update-ca-certificates
COPY --from=builder /go/bin/operator /operator
COPY --from=builder /go/bin/tester /tester
COPY --from=builder /etcd/etcdctl /usr/local/bin/etcdctl

ENTRYPOINT ["/operator"]
CMD ["-config", "/etc/eco/eco.yaml"]
