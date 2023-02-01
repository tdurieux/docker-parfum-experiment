# build
FROM golang:1.18 as builder

WORKDIR /go/src
COPY . /go/src/
RUN CGO_ENABLED=0 go build -a -o kamailio_exporter

# run