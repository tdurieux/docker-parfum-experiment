# build stage
FROM golang:stretch AS builder
WORKDIR /go/src/github.com/CovenantSQL/CookieScanner
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go install -ldflags '-linkmode external -extldflags -static'

# stage runner