# Build
FROM golang:1.16.4-buster as builder
WORKDIR /go/src/github.com/q191201771/lal
ENV GOPROXY=https://goproxy.cn,https://goproxy.io,direct
COPY . .
RUN make build_for_linux

# Output