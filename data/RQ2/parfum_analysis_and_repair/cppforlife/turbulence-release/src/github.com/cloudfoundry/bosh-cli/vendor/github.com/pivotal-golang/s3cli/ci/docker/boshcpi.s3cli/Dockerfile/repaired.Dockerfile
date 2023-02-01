FROM ubuntu:latest

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG C
ENV LC_ALL C

RUN apt-get update && apt-get install --no-install-recommends -y realpath git curl python python-pip python-dateutil python-magic zip jq; && rm -rf /var/lib/apt/lists/*; apt-get clean; pip install --no-cache-dir awscli

RUN cd /tmp && \
    curl -f -O -L https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go*.tar.gz && \
    rm go*.tar.gz

RUN mkdir -p /opt/go
ENV GOPATH /opt/go
ENV PATH /usr/local/go/bin:/opt/go/bin:$PATH

RUN go get github.com/onsi/ginkgo/ginkgo; go get github.com/golang/lint/golint

RUN cd /tmp && \
    curl -f -O -L https://github.com/s3tools/s3cmd/archive/v1.6.0.tar.gz && \
    tar xzf v1.6.0.tar.gz && \
    cd s3cmd-1.6.0 && \
    cp -R s3cmd S3 /usr/local/bin && \
    cd /tmp && \
    rm -rf s3cmd-1.6.0/ v1.6.0.tar.gz
