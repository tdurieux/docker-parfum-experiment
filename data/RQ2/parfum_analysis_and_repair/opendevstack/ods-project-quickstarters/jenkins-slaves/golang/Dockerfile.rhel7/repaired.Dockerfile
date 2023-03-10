FROM cd/jenkins-slave-base

LABEL maintainer="Michael Sauter <michael.sauter@boehringer-ingelheim.com>"

ENV GO_VERSION 1.12.6

RUN cd /tmp && \
    curl -f -LO https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz && \
    rm -f *.tar.gz && \
    cd - && \
    mkdir /go

ENV PATH $PATH:/usr/local/go/bin
ENV GOBIN /usr/local/bin

RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v1.17.1

RUN go get -u github.com/jstemmer/go-junit-report

WORKDIR /go
