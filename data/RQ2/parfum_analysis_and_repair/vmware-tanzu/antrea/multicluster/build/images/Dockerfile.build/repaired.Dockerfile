ARG GO_VERSION
FROM golang:${GO_VERSION} as antrea-build

WORKDIR /antrea

COPY go.mod /antrea/go.mod

RUN go mod download

COPY . /antrea

RUN cd multicluster && make build

FROM gcr.io/distroless/static:nonroot

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="The Docker image to deploy the Antrea Multicluster controller."

USER root

COPY --from=antrea-build /antrea/multicluster/bin/antrea-mc-controller /