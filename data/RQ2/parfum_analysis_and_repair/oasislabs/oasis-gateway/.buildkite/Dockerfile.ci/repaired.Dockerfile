FROM golang:1.14-stretch

ENV BUILDKITE_BUILD_NUMBER ""
ENV BUILDKITE_PULL_REQUEST ""
ENV BUILDKITE_BRANCH ""

# Set GOPROXY to accept go proxy as a build arg and set as an environment
# variable. By default this value is empty and not use a go proxy.
ARG GOPROXY=

RUN apt update && apt install --no-install-recommends -y git build-essential gcc binutils curl protobuf-compiler golang-goprotobuf-dev make && rm -rf /var/lib/apt/lists/*;
RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b /tmp/bin v1.20.1

# Prepare for coverage
RUN go get golang.org/x/tools/cmd/cover

WORKDIR /app
COPY . /app

# make to force pulling all the dependencies
RUN make

# remove the contents in /app
RUN rm -rf /app/*
