# BUILD STAGE
FROM golang:1.14-alpine as builder
RUN apk add --no-cache make git
WORKDIR /repo
COPY . .
RUN CGO_ENABLED=0 ./scripts/build.sh --main main.go --binary sensor

# FINAL STAGE