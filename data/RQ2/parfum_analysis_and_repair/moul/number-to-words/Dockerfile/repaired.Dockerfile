# build
FROM            golang:1.16-alpine as builder
RUN             apk add --no-cache git gcc musl-dev make
ENV             GO111MODULE=on
WORKDIR         /go/src/moul.io/number-to-words
COPY            go.* ./
RUN             go mod download
COPY            . ./
RUN             make install

# minimalist runtime