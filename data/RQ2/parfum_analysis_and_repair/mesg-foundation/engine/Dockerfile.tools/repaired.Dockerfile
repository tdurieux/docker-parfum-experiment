# base Go image version.
FROM golang:1.13.10

WORKDIR /project

# install some dependencies from apt-get.
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y unzip && \
    rm -rf /var/lib/apt/lists/*

# protobuf(protoc) version.
ARG protobuf=3.11.4
ARG gogoprotobuf=1.3.1

# install protobuf(protoc).
RUN wget -q https://github.com/protocolbuffers/protobuf/releases/download/v$protobuf/protoc-$protobuf-linux-x86_64.zip -O /tmp/protobuf.zip && \
    mkdir /tmp/protobuf && \
    unzip /tmp/protobuf.zip -d /tmp/protobuf && \
    mv /tmp/protobuf/bin/* /usr/local/bin/ && \
    mv /tmp/protobuf/include/* /usr/local/include/ && \
    rm -rf /tmp/protobuf

RUN cd /tmp/ && \
    git clone https://github.com/gogo/protobuf.git && \
    cd protobuf && \
    make install && \
    mkdir -p /usr/local/include/gogo/protobuf/ && \
    cp gogoproto/gogo.proto /usr/local/include/gogo/protobuf/

# download gogo proto files
RUN mkdir -p /usr/local/include/gogo/protobuf/ && \
    wget -qO- https://github.com/gogo/protobuf/archive/v${gogoprotobuf}.tar.gz | tar -xzf - protobuf-${gogoprotobuf}/gogoproto/gogo.proto && \
    mv protobuf-${gogoprotobuf}/gogoproto /usr/local/include/gogo/protobuf/

# install dependencies
COPY go.mod go.sum ./
RUN go mod download

RUN go install github.com/golang/protobuf/protoc-gen-go
RUN go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

# verify that mesg-dev container is being used.
ENV MESG_DEV true
