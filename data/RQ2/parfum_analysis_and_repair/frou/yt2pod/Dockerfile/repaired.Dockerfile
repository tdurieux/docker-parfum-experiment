# REF: https://hub.docker.com/_/golang
FROM golang:alpine AS builder
WORKDIR /root/build
ADD . .
# The go compiler will use its version-stamping capability if git is available.
RUN apk --no-cache add git
RUN go build

# REF: https://hub.docker.com/_/alpine
FROM alpine:latest
COPY --from=builder /root/build/yt2pod /usr/local/bin/
# Install the runtime dependencies of yt2pod