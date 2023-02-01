FROM golang:latest

RUN apt-get update && apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;

RUN go get -u github.com/dvyukov/go-fuzz/go-fuzz \
	github.com/dvyukov/go-fuzz/go-fuzz-dep \
	github.com/dvyukov/go-fuzz/go-fuzz-build

COPY . $GOPATH/src/github.com/opencontainers/umoci

WORKDIR $GOPATH/src/github.com/opencontainers/umoci

RUN go clean --modcache && \
    go mod tidy && \
    go mod vendor && \
    rm -r ./vendor

