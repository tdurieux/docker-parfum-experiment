FROM ubuntu:18.04

ARG MODE
RUN apt-get clean && apt-get update &&\
  set -eux &&\
  apt-get --no-install-recommends -y install \
      curl \
      git \
      ca-certificates \
      wget \
      vim \
      sysstat \
      attr \
      net-tools \
      iproute2 \
      make \
      iputils-ping && \
  apt-get -y clean all && rm -rf /var/lib/apt/lists/*;

# Setting ENV variables
ENV GOLANG_VERSION 1.18
COPY deploy/dev/local/aisnode_config.sh /etc/ais/aisnode_config.sh

# Reassign arguments to environment variables so run.sh can use them
ENV GOPATH /go
ENV GOBIN $GOPATH/bin
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV WORKDIR $GOPATH/src/github.com/NVIDIA/aistore

RUN mkdir -p /etc/ais
RUN mkdir /usr/nvidia
RUN mkdir -p $GOPATH/src/github.com/NVIDIA

# Installing go
RUN mkdir -p "$GOPATH/bin"
RUN chmod -R 777 "$GOPATH"
RUN curl -f -LO https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
  tar -C /usr/local -xvzf go${GOLANG_VERSION}.linux-amd64.tar.gz > /dev/null 2>&1 && \
  rm -rf go${GOLANG_VERSION}.linux-amd64.tar.gz

COPY . $GOPATH/src/github.com/NVIDIA/aistore/
WORKDIR $GOPATH/src/github.com/NVIDIA/aistore

# Build it here so it is not done multiple times on each proxy/target: less
# downloading and less time spent on everything.
# TODO: maybe we can do it more elegantly?...
RUN echo "MODE: ${MODE}" && CGO_ENABLED=0 AIS_BACKEND_PROVIDERS="ais aws azure gcp hdfs" MODE="${MODE}" make node

EXPOSE 8080

