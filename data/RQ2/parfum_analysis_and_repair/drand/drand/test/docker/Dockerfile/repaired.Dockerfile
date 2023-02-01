FROM golang:1.17.1-buster AS builder

ENV GOPATH /go
ENV SRC_PATH $GOPATH/src/github.com/drand/drand/
ENV GOPROXY https://proxy.golang.org

# Get the TLS CA certificates, they're not provided by busybox.
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY go.* $SRC_PATH
WORKDIR $SRC_PATH
RUN go mod download

COPY . $SRC_PATH
RUN make client
RUN make relay-http
RUN make relay-gossip

FROM busybox:1-glibc

ENV GOPATH                 /go
ENV SRC_PATH               /go/src/github.com/drand/drand
ENV DRAND_HOME             /data/drand

COPY --from=builder $SRC_PATH/drand-client /usr/local/bin/drand-client
COPY --from=builder $SRC_PATH/drand-relay-http /usr/local/bin/drand-relay-http
COPY --from=builder $SRC_PATH/drand-relay-gossip /usr/local/bin/drand-relay-gossip

VOLUME $DRAND_HOME
ENTRYPOINT [""]

# Defaults for drand go here
CMD [""]
