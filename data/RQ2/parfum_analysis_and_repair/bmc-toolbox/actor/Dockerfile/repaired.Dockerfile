# Build
FROM golang:1 as build

WORKDIR /build
ADD . .

# Tests
RUN go test -mod=vendor ./...

RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o actor .

# Run