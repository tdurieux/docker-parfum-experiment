FROM golang:latest

# Install grpc
RUN go get -u github.com/golang/protobuf/protoc-gen-go


# update
RUN apt-get update

# build-essentials
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# RUN apt-get update && apt-get upgrade && apt-get install -y pkg-config build-essential libudev-dev

# Install protoc and zip system library
RUN apt-get update && apt-get install --no-install-recommends -y zip && \
    mkdir /opt/protoc && cd /opt/protoc && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip && \
    unzip protoc-3.19.4-linux-x86_64.zip && rm -rf /var/lib/apt/lists/*;

ENV PATH=$PATH:$GOPATH/bin:/opt/protoc/bin

COPY . .

RUN make protogen_local && echo "Done."
