# build stage
FROM skrop/skrop-build AS build-env

ADD . /go/src/github.com/zalando-stups/skrop
    WORKDIR /go/src/github.com/zalando-stups/skrop

RUN go build ./cmd/skrop

# final stage
FROM skrop/alpine-mozjpeg-vips:3.3.1-8.7.0

ARG ROUTES_FILE

# Build-time metadata as defined at http://label-schema.org