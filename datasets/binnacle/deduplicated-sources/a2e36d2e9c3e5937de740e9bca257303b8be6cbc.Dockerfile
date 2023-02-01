FROM golang:1.11 AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    git make curl build-essential bash git autoconf automake libtool unzip file ca-certificates
RUN git clone https://github.com/google/protobuf /tmp/protobuf && \
    cd /tmp/protobuf && \
    git checkout 3.5.x && \
    ./autogen.sh && \
    ./configure && make install
RUN ldconfig
RUN go get -v github.com/LK4D4/vndr
RUN go get -v github.com/golang/protobuf/protoc-gen-go
RUN go get -v github.com/gogo/protobuf/protoc-gen-gofast
RUN go get -v github.com/gogo/protobuf/proto
RUN go get -v github.com/gogo/protobuf/gogoproto
RUN go get -v github.com/gogo/protobuf/protoc-gen-gogo
RUN go get -v github.com/gogo/protobuf/protoc-gen-gogofast
RUN go get -v github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
RUN go get -v github.com/stevvooe/protobuild
RUN go get -v golang.org/x/lint/golint
WORKDIR /go/src/github.com/ehazlett/stellar
COPY . /go/src/github.com/ehazlett/stellar
RUN make

FROM alpine:latest
COPY --from=build /go/src/github.com/ehazlett/stellar/bin/* /bin/
