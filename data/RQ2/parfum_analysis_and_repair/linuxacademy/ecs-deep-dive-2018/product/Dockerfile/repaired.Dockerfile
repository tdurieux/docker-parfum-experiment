# This is a multi-stage build.

# build stage
FROM golang:1.10 AS builder
WORKDIR /go/src/github.com/linuxacademy/product
COPY main.go .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# final stage
FROM scratch
WORKDIR /root/
COPY --from=builder /go/src/github.com/linuxacademy/product/app .

# Metadata params
ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

# Metadata