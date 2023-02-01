FROM golang:1.10

ENV PROTOC_VERSION 3.5.1

# update everything
RUN apt-get update

# install graphviz
RUN apt-get install -y graphviz

# install s3cmd
RUN apt-get install -y s3cmd

# install protoc
RUN apt-get install -y unzip && \
    wget https://github.com/google/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    mv bin/* /usr/bin/ && \
    mv include/google /usr/include/google && \
    go get -v github.com/golang/protobuf/protoc-gen-go github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger && \
    apt-get purge -y unzip

# install gox
RUN go get -v github.com/mitchellh/gox

# install glide
RUN curl https://glide.sh/get | sh

# install fuzzers
RUN go get -v github.com/dvyukov/go-fuzz/go-fuzz
RUN go get -v github.com/dvyukov/go-fuzz/go-fuzz-build

# install man
RUN apt-get install -y man

WORKDIR /go
CMD /bin/bash
