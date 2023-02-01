# This Dockerfile is used for cluster testing - it produces a much larger image
# and includes all of Go as well as some utilities.

FROM golang:1.11

LABEL maintainer "dev@pilosa.com"

COPY . /go/src/github.com/pilosa/pilosa/

RUN cd /go/src/github.com/pilosa/pilosa \
    && GO111MODULE=on make vendor

RUN cd /go/src/github.com/pilosa/pilosa \
    && CGO_ENABLED=0 make install FLAGS="-a"

# download pumba for fault injection