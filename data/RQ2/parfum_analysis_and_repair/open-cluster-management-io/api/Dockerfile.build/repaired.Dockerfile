FROM fedora:34

ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:/go/bin:$PATH

ARG GO_VERSION=1.18.2
RUN curl -f -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm -rf go${GO_VERSION}.linux-amd64.tar.gz
RUN go get -u -v golang.org/x/tools/cmd/...

RUN dnf -y install make git unzip findutils
RUN curl -f -LO https://github.com/google/protobuf/releases/download/v3.0.2/protoc-3.0.2-linux-x86_64.zip && \
    mkdir protoc && \
    unzip protoc-3.0.2-linux-x86_64.zip -d protoc/ && \
    mv protoc/bin/protoc /usr/bin && \
    rm -rf protoc
