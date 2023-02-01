ARG GO_VERSION
FROM golang:${GO_VERSION}-stretch

RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/elastic/fleet-server

ENTRYPOINT [ "make", "release" ]
