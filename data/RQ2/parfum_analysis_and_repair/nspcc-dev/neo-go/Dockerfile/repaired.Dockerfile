# Builder image
# Keep go version in sync with Build GA job.
FROM golang:1.18-alpine as builder

# Display go version for information purposes.
RUN go version

RUN set -x \
    && apk add --no-cache git make \
    && mkdir -p /tmp

COPY . /neo-go

WORKDIR /neo-go

ARG REPO=repository
ARG VERSION=dev

RUN make build

# Executable image