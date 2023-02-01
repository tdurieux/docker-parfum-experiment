FROM golang:1.12 AS build

WORKDIR /go/src/github.com/Jeffail/benthos/
COPY . /go/src/github.com/Jeffail/benthos/

RUN apt-get update && apt-get install -y --no-install-recommends libzmq3-dev

ENV GO111MODULE on
RUN GOOS=linux GOFLAGS=-mod=vendor make TAGS=ZMQ4

FROM debian:stretch

LABEL maintainer="Ashley Jeffs <ash@jeffail.uk>"

WORKDIR /root/

RUN apt-get update && apt-get install -y --no-install-recommends libzmq3-dev

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/src/github.com/Jeffail/benthos/target/bin/benthos .
COPY ./config/env/default.yaml /benthos.yaml

EXPOSE 4195

ENTRYPOINT ["./benthos", "-c", "/benthos.yaml"]
