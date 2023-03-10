ARG BUILDER_IMAGE=fission/builder
ARG GO_VERSION

FROM ${BUILDER_IMAGE}

FROM golang:${GO_VERSION}

ENV GOPATH /usr
ENV GO111MODULE on
WORKDIR ${GOPATH}

COPY --from=0 /builder /builder
ADD build.sh /usr/local/bin/build