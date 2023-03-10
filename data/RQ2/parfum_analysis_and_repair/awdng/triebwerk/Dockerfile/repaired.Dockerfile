# Builder Image
FROM golang:1.13beta1-alpine3.10 as builder

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git bash make

WORKDIR /triebwerk

COPY Makefile go.mod go.sum ./

RUN make tools

COPY . ./

RUN chmod +x docker/docker-entrypoint.sh \
    && make build-static

# Run image