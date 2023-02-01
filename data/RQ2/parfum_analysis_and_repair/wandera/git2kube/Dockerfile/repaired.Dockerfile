# Builder image
FROM golang:1.14.3 AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download

# Docker Cloud args, from hooks/build.
ARG CACHE_TAG
ENV CACHE_TAG ${CACHE_TAG}

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -ldflags '-w -s -X 'github.com/wandera/git2kube/cmd.Version=${CACHE_TAG}

# Runtime image