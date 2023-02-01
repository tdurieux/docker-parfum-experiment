# base Go image version.
FROM golang:1.11.4-stretch

WORKDIR /project

# install dependencies
COPY go.mod go.sum ./
RUN go mod download

VOLUME /project

# install some dependencies from apt-get.
RUN apt-get update -y && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# protobuf(protoc) version.
ARG protobuf=3.8.0

# install protobuf(protoc).
RUN wget -q https://github.com/protocolbuffers/protobuf/releases/download/v$protobuf/protoc-$protobuf-linux-x86_64.zip -O /tmp/protobuf.zip && \
    mkdir /tmp/protobuf && \
    unzip /tmp/protobuf.zip -d /tmp/protobuf && \
    mv /tmp/protobuf/bin/protoc /usr/local/bin/protoc && \
    rm -rf /tmp/*

RUN go install github.com/go-bindata/go-bindata/go-bindata
RUN go install github.com/golang/protobuf/protoc-gen-go
RUN go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc
RUN go install github.com/vektra/mockery/.../

# verify that mesg-dev container is being used.
ENV MESG_DEV true
