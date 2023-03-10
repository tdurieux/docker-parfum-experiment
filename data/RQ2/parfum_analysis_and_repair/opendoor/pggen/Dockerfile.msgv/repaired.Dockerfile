#
# This docker file is for running tests against the earliest support go
# version.
#
FROM golang:1.13-alpine

# we need postgresql-client so we can set up our database with psql
# for testing and `go` uses `git` to fetch deps for us. musl-dev
# and gcc are needed for cgo support.
RUN apk add --no-cache postgresql-client git musl-dev gcc bash

WORKDIR /pggen

COPY go.sum .
COPY go.mod .
RUN go mod download

# volumes don't work well in circle, so just copy all the source code
# into the image itself.