# Stage build
FROM golang:1.17.7 as builder

WORKDIR /go/src/github.com/ccamel

COPY . .

RUN make build-linux-amd64

# Stage run