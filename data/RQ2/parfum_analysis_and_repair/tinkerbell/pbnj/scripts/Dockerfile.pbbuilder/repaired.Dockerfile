FROM golang:1.16.9

ENV GO111MODULE=on

COPY scripts/protoc.sh /protoc.sh
RUN /protoc.sh deps