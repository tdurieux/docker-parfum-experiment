FROM ubuntu:16.04

ENV GOVERSION 1.11

# Install Base Tools
RUN apt update && \
        apt install -y git make vim curl wget g++ && \
        rm -rf /var/lib/apt/lists

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
        apt install -y nodejs && \
        rm -rf /var/lib/apt/lists

# Install Go
RUN mkdir /goroot && \
    mkdir /gopath && \
    curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | \
    tar xzf - -C /goroot --strip-components=1

ENV CGO_ENABLED 1
ENV GOPATH /gopath
ENV GOROOT /goroot
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

# Install Gometalinter
RUN curl -L https://git.io/vp6lP | sh

WORKDIR $GOPATH/src/github.com/iost-official/go-iost

CMD ["make"]
