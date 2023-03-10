# Build image: golang:1.14-alpine3.13
FROM golang:1.17-alpine3.15 as build

WORKDIR /app

COPY . .
RUN go mod download && go build -o ./build/gau ./cmd/gau

ENTRYPOINT ["/app/gau/build/gau"]

# Release image: alpine:3.14.1