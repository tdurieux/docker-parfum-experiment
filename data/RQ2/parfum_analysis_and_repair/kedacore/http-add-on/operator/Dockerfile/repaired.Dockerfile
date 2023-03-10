# adapted from Athens 
# https://github.com/gomods/athens/blob/main/cmd/proxy/Dockerfile
ARG GOLANG_VERSION=1.18.3
ARG GOARCH=amd64
ARG GOOS=linux
ARG VERSION="unset"

FROM golang:${GOLANG_VERSION}-alpine AS builder

WORKDIR $GOPATH/src/github.com/kedacore/http-add-on

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY . .

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=${GOOS}
ENV GOARCH=${GOARCH}
ENV GOPROXY="https://proxy.golang.org"

# Build
RUN go build -ldflags "-X github.com/kedacore/http-add-on/pkg/build.version=${VERSION}" -a -o /bin/operator ./operator

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details