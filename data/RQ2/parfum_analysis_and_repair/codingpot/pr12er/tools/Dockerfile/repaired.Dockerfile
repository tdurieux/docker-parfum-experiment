FROM ubuntu:latest AS builder
RUN apt update && apt install --no-install-recommends -y git curl make tar gzip bash unzip gcc && rm -rf /var/lib/apt/lists/*;
WORKDIR /temp
# Set up ENV variable.
ENV PATH=$PATH:/temp/flutter/bin:/usr/local/go/bin:/root/.local/bin:/root/go/bin
# Install Flutter.
RUN git clone https://github.com/flutter/flutter.git -b stable
RUN flutter upgrade
RUN flutter doctor
# Install Go.
COPY --from=golang:1.18 /usr/local/go/ /usr/local/go/

# Install dependencies
WORKDIR /workspace
COPY ./client/pubspec.lock ./client/pubspec.yaml ./client/
COPY ./server/go.* ./server/
COPY ./server/cmd/tools/tools.go ./server/cmd/tools/
COPY ./dbctl/go.* ./dbctl/
COPY Makefile .

RUN make install.buf install.protoc install.go.notidy install.dart
RUN rm -rf client server Makefile dbctl

# Install golangci-lint.
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.41.1

ENV PATH=$PATH:/root/.pub-cache/bin

WORKDIR /workspace

CMD ["/bin/bash"]
