# Build the manager binary
FROM golang:1.18 as builder

## GOLANG env
ARG GOPROXY="https://proxy.golang.org|direct"
ARG GO111MODULE="on"
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

# Copy go.mod and download dependencies
WORKDIR /aws-simple-ec2-cli
COPY go.mod .
COPY go.sum .
RUN go mod download

# Build
COPY . .
RUN make build
# In case the target is build for testing:
# $ docker build  --target=builder -t test .
CMD ["/aws-simple-ec2-cli/build/simple-ec2"]

# Copy the binary into a thin image