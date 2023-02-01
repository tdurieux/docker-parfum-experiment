# Build the converter binary
FROM golang:1.17-alpine3.14 as builder

WORKDIR /workspace
COPY . /workspace

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o converter cmd/converter/main.go

# Use distroless as minimal base image to package the converter binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details