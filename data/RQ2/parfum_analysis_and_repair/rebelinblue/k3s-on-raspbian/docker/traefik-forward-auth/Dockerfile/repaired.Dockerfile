#
# Compile
#

FROM golang:1.12-alpine AS builder

ARG FORWARD_AUTH_VERSION
ARG BUILD_DATE
ARG VCS_REF

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=arm64

WORKDIR /go/src/github.com/funkypenguin/traefik-forward-auth

RUN apk add --no-cache git

RUN git clone https://github.com/funkypenguin/traefik-forward-auth.git . && \
    git checkout master
    #${FORWARD_AUTH_VERSION}

# Add libraries
RUN apk add --no-cache git && \
  go get "github.com/namsral/flag" && \
  go get "github.com/sirupsen/logrus" && \
  apk del git

# Copy & build
RUN go build -a -installsuffix nocgo -o /traefik-forward-auth .

#
# Deploy
#