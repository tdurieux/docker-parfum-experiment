ARG GO_VERSION
FROM golang:${GO_VERSION} as antrea-build

WORKDIR /antrea

COPY go.mod /antrea/go.mod

RUN go mod download

COPY . /antrea

RUN make antrea-agent-simulator


FROM ubuntu:20.04

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="The Docker image to deploy the Antrea simulator."

USER root

COPY --from=antrea-build /antrea/bin/* /usr/local/bin/