###################################
# 1. Build in a Go-based image   #
###################################
FROM golang:1.12-alpine as builder
RUN apk add --no-cache git ca-certificates # add deps here (like make) if needed
WORKDIR /go/hostyoself
COPY . .
# any pre-requisities to building should be added here
RUN go generate -v
RUN go build -v

###################################
# 2. Copy into a clean image     #
###################################