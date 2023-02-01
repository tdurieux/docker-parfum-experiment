FROM ubuntu:xenial

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y postgresql-client golang-go ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD . /go/src/github.com/CanonicalLtd/serial-vault

WORKDIR /go/src/github.com/CanonicalLtd/serial-vault
# get dependencies
RUN go get ./...

COPY ./docker-compose/settings.yaml /go/src/github.com/CanonicalLtd/serial-vault
COPY ./docker-compose/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
