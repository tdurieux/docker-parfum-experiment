FROM golang:alpine

RUN apk --update --no-cache add fuse fuse-dev git
RUN go get github.com/mitre/fusera/...

RUN cd ~ && mkdir studies

