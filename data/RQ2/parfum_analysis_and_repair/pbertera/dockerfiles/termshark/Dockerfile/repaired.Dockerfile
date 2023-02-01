FROM golang:alpine

RUN apk update && apk add --no-cache tshark git && \
    go get github.com/gcla/termshark/cmd/termshark
ENTRYPOINT ["/go/bin/termshark"]

