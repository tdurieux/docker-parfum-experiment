FROM ubuntu:latest

# This dockerfile is capabable of performing all
# build/test/package/deploy actions needed for Kapacitor.

MAINTAINER support@influxdb.com

RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y \
    python-software-properties \
    software-properties-common \
    wget \
    unzip \
    git \
    mercurial \
    make \
    ruby \
    ruby-dev \
    rpm \
    zip \
    python \
    python-boto \
    build-essential \
    autoconf \
    automake \
    libtool \
    python-setuptools \
    curl && rm -rf /var/lib/apt/lists/*;

RUN gem install fpm

# Install protobuf3 protoc binary
ENV PROTO_VERSION 3.0.0
RUN wget -q https://github.com/google/protobuf/releases/download/v${PROTO_VERSION}/protoc-${PROTO_VERSION}-linux-x86_64.zip \
    && unzip -j protoc-${PROTO_VERSION}-linux-x86_64.zip bin/protoc -d /bin \
    rm protoc-${PROTO_VERSION}-linux-x86_64.zip

# Install protobuf3 python library
RUN wget -q https://github.com/google/protobuf/releases/download/v${PROTO_VERSION}/protobuf-python-${PROTO_VERSION}.tar.gz \
    && tar -xf protobuf-python-${PROTO_VERSION}.tar.gz \
    && cd /protobuf-${PROTO_VERSION}/python \
    && python setup.py install \
    && rm -rf /protobuf-${PROTO_VERSION} protobuf-python-${PROTO_VERSION}.tar.gz

# Install go
ENV GOPATH /root/go
ENV GO_VERSION 1.7.5
ENV GO_ARCH amd64
RUN wget -q https://storage.googleapis.com/golang/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz; \
   tar -C /usr/local/ -xf /go${GO_VERSION}.linux-${GO_ARCH}.tar.gz ; \
   rm /go${GO_VERSION}.linux-${GO_ARCH}.tar.gz
ENV PATH /usr/local/go/bin:$PATH

ENV PROJECT_DIR $GOPATH/src/github.com/influxdata/kapacitor
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR

VOLUME $PROJECT_DIR
VOLUME /root/go/src

# Configure local git
RUN git config --global user.email "support@influxdb.com"
RUN git config --global user.Name "Docker Builder"

ENTRYPOINT [ "/root/go/src/github.com/influxdata/kapacitor/build.py" ]
