FROM fedora:latest

ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:$PATH

RUN dnf -y install make git unzip wget findutils gcc diffutils

RUN wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz && \
    rm go1.17.6.linux-amd64.tar.gz

RUN go install golang.org/x/tools/cmd/goimports@latest
RUN wget https://github.com/google/protobuf/releases/download/v3.0.2/protoc-3.0.2-linux-x86_64.zip && \
    mkdir protoc && \
    unzip protoc-3.0.2-linux-x86_64.zip -d protoc/ && \
    mv protoc/bin/protoc /usr/bin && \
    rm -rf protoc