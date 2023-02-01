FROM golang:1.18.1

RUN apt update && apt install --no-install-recommends -y git gcc musl-dev curl iputils-ping telnet graphviz && rm -rf /var/lib/apt/lists/*

ENV GOPATH /go
ENV GOBIN /go/bin

WORKDIR /workspace

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.45.2

RUN go install -v golang.org/x/tools/gopls@v0.8.3
RUN go install -v github.com/rogpeppe/godef@v1.1.2
RUN go install -v github.com/rakyll/gotest@v0.0.6
RUN go install -v github.com/ramya-rao-a/go-outline@1.0.0
RUN go install -v github.com/go-delve/delve/cmd/dlv@v1.8.1

COPY go.mod ./
COPY go.sum ./
RUN go mod download

# Aliases
RUN echo "alias ll='ls -alF'" >> /etc/bash.bashrc
RUN echo "alias hammer-clean='go clean -testcache'" >> /etc/bash.bashrc
RUN echo "alias hammer-test-n-cover='gotest -coverpkg=./... -coverprofile=coverage.out ./... && go tool cover -func coverage.out'" >> /etc/bash.bashrc
