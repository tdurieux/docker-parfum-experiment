# builder

FROM golang:1.17-alpine AS builder

WORKDIR /root/
COPY . .
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o miaokeeper .

# image

FROM alpine:latest
LABEL maintainer=BBAliance

# disabling cgo when built, so no need to install libc6-compat