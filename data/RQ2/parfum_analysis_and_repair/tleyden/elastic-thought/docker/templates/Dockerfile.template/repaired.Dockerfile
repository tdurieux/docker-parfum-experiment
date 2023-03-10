FROM tleyden5iwx/caffe-{{ .ProcessorType }}-master

MAINTAINER Traun Leyden tleyden@couchbase.com

ENV GOPATH /opt/go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOPATH/bin:$GOROOT/bin

# Get dependencies
RUN apt-get update && \
    apt-get -q --no-install-recommends -y install \
    mercurial \
    make \
    binutils \
    bison \
    build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $GOPATH

# Download and install Go 1.4
RUN wget https://golang.org/dl/go1.4.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz && \
    rm go1.4.2.linux-amd64.tar.gz

# Add refresh script
ADD scripts/refresh-elastic-thought /usr/local/bin/

# Go get ElasticThought
RUN go get -u -v -t github.com/tleyden/elastic-thought/...&& \
    cd $GOPATH/src/github.com/tleyden/elastic-thought && \
    git log -3

# Export default port
EXPORT 8080