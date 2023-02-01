# Build
FROM golang:1.17 as builder
ADD . /src
WORKDIR /src
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o server

# Run