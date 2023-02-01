# STEP 1 build executable binary
FROM golang:1.14-alpine as builder

WORKDIR $GOPATH/src/github.com/asciimoo/morty

RUN apk add --no-cache git

COPY . .
RUN go get -d -v
RUN gofmt -l ./
#RUN go vet -v ./...
#RUN go test -v ./...
RUN go build .

# STEP 2 build the image including only the binary