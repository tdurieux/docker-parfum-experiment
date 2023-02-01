# Stage 1: Build website
FROM --platform=${BUILDPLATFORM} docker.io/node:18 as web-builder

COPY ./web /static/

ENV NODE_ENV=production
RUN cd /static && npm ci && npm run build-proxy

# Stage 2: Build
FROM docker.io/golang:1.18.3-bullseye AS builder

WORKDIR /go/src/goauthentik.io

COPY . .

ENV CGO_ENABLED=0
RUN go build -o /go/proxy ./cmd/proxy

# Stage 3: Run