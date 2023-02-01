FROM golang:1.18.0-alpine3.15
ARG version
RUN apk add --no-cache build-base
WORKDIR /app
COPY go.* ./
RUN go mod download
