FROM golang:1.10 as build-env

# Install additional dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y git curl unzip jq file zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip && unzip protoc-3.11.4-linux-x86_64.zip -d protoc3 && chmod +x protoc3/bin/* && mv protoc3/bin/* /usr/local/bin && mv protoc3/include/* /usr/local/include/
RUN curl -f -L https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v1.14.3/protoc-gen-grpc-gateway-v1.14.3-linux-x86_64 -o $GOPATH/bin/protoc-gen-grpc-gateway && chmod +x $GOPATH/bin/protoc-gen-grpc-gateway
RUN curl -f -L https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v1.14.3/protoc-gen-swagger-v1.14.3-linux-x86_64 -o $GOPATH/bin/protoc-gen-swagger && chmod +x $GOPATH/bin/protoc-gen-swagger

RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN go get github.com/jteeuwen/go-bindata/...

env PATH $GOPATH/bin:$PATH
EXPOSE 8086

RUN mkdir -p $GOPATH/src/github.com/nre-learning

COPY hack/compile-binaries.sh /
