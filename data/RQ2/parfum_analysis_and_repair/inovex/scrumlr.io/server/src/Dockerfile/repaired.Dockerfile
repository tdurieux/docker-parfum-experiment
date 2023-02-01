# Build application
FROM golang:1.17
WORKDIR /go/src/github.com/inovex/scrumlr.io/
COPY ./ .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -o main

# Start application