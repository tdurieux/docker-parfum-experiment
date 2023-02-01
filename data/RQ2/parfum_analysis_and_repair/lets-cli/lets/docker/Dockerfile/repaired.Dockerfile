FROM golang:1.18.3-bullseye

ENV GOPROXY https://proxy.golang.org
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    git gcc \
    zsh && rm -rf /var/lib/apt/lists/*; # for zsh completion tests

RUN cd /tmp && \
    git clone https://github.com/bats-core/bats-core && \
    git clone https://github.com/bats-core/bats-support.git /bats/bats-support && \
    git clone https://github.com/bats-core/bats-assert.git /bats/bats-assert && \
    cd bats-core && \
    ./install.sh /usr && \
    echo Bats installed

RUN go install gotest.tools/gotestsum@latest

COPY go.mod .
COPY go.sum .

RUN go mod download
