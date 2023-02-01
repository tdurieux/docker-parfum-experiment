# Stage 1: Build
FROM docker.io/golang:1.18.3-bullseye AS builder

WORKDIR /go/src/goauthentik.io

COPY . .
ENV CGO_ENABLED=0
RUN go build -o /go/ldap ./cmd/ldap

# Stage 2: Run