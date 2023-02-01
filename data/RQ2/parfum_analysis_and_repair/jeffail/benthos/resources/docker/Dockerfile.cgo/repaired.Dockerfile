FROM golang:1.18 AS build

ENV CGO_ENABLED=1
ENV GOOS=linux

WORKDIR /go/src/github.com/benthosdev/benthos/
# Update dependencies: On unchanged dependencies, cached layer will be reused
COPY go.* /go/src/github.com/benthosdev/benthos/
RUN go mod download

RUN apt-get update && apt-get install -y --no-install-recommends libzmq3-dev && rm -rf /var/lib/apt/lists/*;

# Build
COPY . /go/src/github.com/benthosdev/benthos/

RUN make TAGS=x_benthos_extra

# Pack
FROM debian:stretch

LABEL maintainer="Ashley Jeffs <ash@jeffail.uk>"

WORKDIR /root/

RUN apt-get update && apt-get install -y --no-install-recommends libzmq3-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/src/github.com/benthosdev/benthos/target/bin/benthos .
COPY ./config/docker.yaml /benthos.yaml

EXPOSE 4195

ENTRYPOINT ["./benthos"]

CMD ["-c", "/benthos.yaml"]
