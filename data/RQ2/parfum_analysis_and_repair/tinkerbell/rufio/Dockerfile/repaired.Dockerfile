# Build the manager binary
FROM golang:1.18 AS builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY ./ ./

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager main.go

FROM alpine:3.15

# Install ipmitool required by the third party BMC lib.
RUN apk add --no-cache --upgrade ipmitool=1.8.18-r10

COPY --from=builder /workspace/manager .

USER 65532:65532
ENTRYPOINT ["/manager"]
