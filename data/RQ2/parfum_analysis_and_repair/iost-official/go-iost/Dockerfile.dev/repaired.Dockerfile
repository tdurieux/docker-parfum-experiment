FROM ubuntu:18.04

ENV GOVERSION 1.18

# Install Base Tools
RUN apt update && \
        apt install --no-install-recommends -y git make curl g++ && \
        rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN mkdir /goroot && \
    curl -f https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | \
    tar xzf - -C /goroot --strip-components=1

ENV CGO_ENABLED 1
ENV GOROOT /goroot
ENV PATH $GOROOT/bin:$PATH

# Install golangci-lint
RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b /usr/local/bin v1.37.0

WORKDIR /go-iost

CMD ["make"]
