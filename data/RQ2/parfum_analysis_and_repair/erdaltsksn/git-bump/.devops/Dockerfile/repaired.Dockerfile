# Args for Go version
ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine3.16

# Install necessary packages