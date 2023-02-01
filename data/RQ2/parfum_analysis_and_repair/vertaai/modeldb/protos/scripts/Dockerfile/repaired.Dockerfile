FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common \
      unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o /tmp/go.tgz https://dl.google.com/go/go1.14.linux-amd64.tar.gz && \
    tar -xvzf /tmp/go.tgz -C /tmp && \
    mv /tmp/go /usr/local && \
    rm -rf /tmp/go* && rm /tmp/go.tgz

USER root
ENV HOME /root
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

# RUN PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip && \
#     curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/$PROTOC_ZIP && \
#     unzip -o $PROTOC_ZIP -d /usr/local bin/protoc && \
#     unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && \
#     rm -f $PROTOC_ZIP

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

COPY get_dependencies.sh get_dependencies.sh
RUN ./get_dependencies.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;

# RUN pip3 install protobuf==3.11.3
RUN pip3 install --no-cache-dir grpcio-tools==1.27.2 grpcio==1.27.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN pip3 install --no-cache-dir pystache==0.5.4 Click==7.0
