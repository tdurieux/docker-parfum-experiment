# BUILD
FROM golang:1.13-alpine as builder

RUN apk add --no-cache gcc build-base

RUN mkdir /app
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go test -v ./...

RUN GIT_COMMIT=$(git rev-parse --short HEAD 2> /dev/null || true) \
 && BUILDTIME=$(TZ=UTC date -u '+%Y-%m-%dT%H:%M:%SZ') \
 && VERSION=$(git describe --abbrev=0 --tags 2> /dev/null || true) \
 && CGO_ENABLED=0 GOOS=linux go build --ldflags "-s -w \
    -X github.com/labbsr0x/bindman-dns-bind9/version.Version=${VERSION:-unknow-version} \
    -X github.com/labbsr0x/bindman-dns-bind9/version.GitCommit=${GIT_COMMIT} \
    -X github.com/labbsr0x/bindman-dns-bind9/version.BuildTime=${BUILDTIME}" \
    -a -installsuffix cgo -o /bindman-dns-bind9 main.go

## PKG