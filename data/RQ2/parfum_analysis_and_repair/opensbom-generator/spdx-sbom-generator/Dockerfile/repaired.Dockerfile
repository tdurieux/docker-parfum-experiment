# SPDX-License-Identifier: Apache-2.0

FROM golang:1.16-alpine AS build
ARG VERSION=latest
ARG GIT_HASH

WORKDIR /src

# Allow for caching
COPY go.mod go.sum ./
RUN go mod download

COPY / .

RUN GO111MODULE=on GOFLAGS=-mod=vendor go mod vendor
RUN GO111MODULE=on GOFLAGS=-mod=vendor go mod tidy

RUN GO111MODULE=on GOFLAGS=-mod=vendor CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o spdx-sbom-generator ./cmd/generator/generator.go

FROM alpine
ENV USERNAME=spdx-sbom-generator
# Ruby
RUN apk add --no-cache --update ruby && gem install bundler

# Go
RUN apk add --no-cache go

# Java
RUN apk add --no-cache --update maven

# Node
RUN apk add --no-cache --update nodejs npm && npm install -g yarn && npm cache clean --force;

COPY --from=build /src/spdx-sbom-generator /spdx-sbom-generator

ENTRYPOINT ["/spdx-sbom-generator"]

CMD ["-h"]
