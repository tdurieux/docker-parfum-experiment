# Should be started with:
# docker run -ti -p 2121-2130:2121-2130 fclairamb/ftpserver

# Preparing the build environment
FROM golang:1.18-alpine AS builder
ENV GOFLAGS="-mod=readonly"
RUN apk add --update --no-cache bash ca-certificates curl git
RUN mkdir -p /workspace
WORKDIR /workspace

# Building
COPY . .
RUN go build -v -o ftpserver

# Preparing the final image