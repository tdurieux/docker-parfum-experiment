FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Michael Sauter <michael.sauter@boehringer-ingelheim.com>"

ARG goDistributionUrl

RUN yum install -y gcc gcc-c++ && rm -rf /var/cache/yum

RUN cd /tmp && \
    curl -LfSso /tmp/go.tar.gz $goDistributionUrl && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm -f /tmp/go.tar.gz && \
    cd - && \
    mkdir /go

ENV PATH $PATH:/usr/local/go/bin
ENV GOBIN /usr/local/bin

COPY install-golangci-lint.sh /tmp/install-golangci-lint.sh
RUN /tmp/install-golangci-lint.sh -b /usr/local/bin v1.25.0 && \
    rm -f /tmp/install-golangci-lint.sh

RUN go get -u github.com/jstemmer/go-junit-report

RUN mkdir -p /home/jenkins/go && chmod g+w /home/jenkins/go

WORKDIR /go
