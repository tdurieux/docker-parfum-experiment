FROM golang:1.16

RUN go get github.com/mitchellh/gox

ENV CGO_ENABLED=0

COPY . /go/src/github.com/realestate-com-au/shush
WORKDIR /go/src/github.com/realestate-com-au/shush
RUN gox -osarch "linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64"