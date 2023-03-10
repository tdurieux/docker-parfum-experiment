# syntax=docker.io/docker/dockerfile:1.3@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2
FROM docker.io/golang:1.17.5@sha256:90d1ab81f3d157ca649a9ff8d251691b810d95ea6023a03cdca139df58bca599

RUN useradd -u 1000 -U -m -d /home/lint lint
USER 1000
WORKDIR /home/lint

# install goimports
RUN go install golang.org/x/tools/cmd/goimports@latest

# install golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
	sh -s -- -b $(go env GOPATH)/bin v1.46.2