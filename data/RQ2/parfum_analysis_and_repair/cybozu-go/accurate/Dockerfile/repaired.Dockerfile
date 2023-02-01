# Build the manager binary
FROM quay.io/cybozu/golang:1.17-focal as builder

COPY ./ .
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o accurate-controller ./cmd/accurate-controller

# the controller image