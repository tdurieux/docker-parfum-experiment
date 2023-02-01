FROM golang:1.18-alpine

ARG flavor

RUN apk add -U --no-cache ca-certificates git make

COPY . /src
WORKDIR /src

RUN CGO_ENABLED=0 FLAVOR="$flavor" make ci