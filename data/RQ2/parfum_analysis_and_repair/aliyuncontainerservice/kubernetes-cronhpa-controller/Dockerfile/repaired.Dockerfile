# Build the manager binary
FROM golang:1.14.2 as builder

# Copy in the go src
WORKDIR /go/src/github.com/AliyunContainerService/kubernetes-cronhpa-controller
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=off go build -a -o kubernetes-cronhpa-controller github.com/AliyunContainerService/kubernetes-cronhpa-controller/cmd/kubernetes-cronhpa-controller

# Copy the controller-manager into a thin image