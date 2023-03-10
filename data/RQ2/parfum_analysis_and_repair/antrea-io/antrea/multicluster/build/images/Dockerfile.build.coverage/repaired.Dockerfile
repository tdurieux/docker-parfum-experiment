ARG GO_VERSION
FROM golang:${GO_VERSION} as antrea-build

WORKDIR /antrea

COPY go.mod /antrea/go.mod

RUN go mod download

COPY . /antrea

RUN cd multicluster && make antrea-mc-instr-binary

FROM ubuntu:20.04

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="The Docker image to deploy the Antrea Multicluster controller with code coverage measurement enabled (used for testing)."

USER root

COPY --from=antrea-build /antrea/multicluster/bin/antrea-mc-controller-coverage /