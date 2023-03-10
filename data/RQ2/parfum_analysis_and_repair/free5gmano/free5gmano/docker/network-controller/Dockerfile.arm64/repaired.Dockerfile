FROM golang:1.11-alpine3.7

RUN apk add --no-cache protobuf ca-certificates git make gcc libc-dev

WORKDIR /go/src/github.com/linkernetworks/

RUN git clone https://github.com/linkernetworks/network-controller.git

WORKDIR /go/src/github.com/linkernetworks/network-controller

RUN go get -u github.com/golang/protobuf/proto &&\
    go get -u github.com/kardianos/govendor

ENV GIT_TAG="v1.2.0"
RUN go get -d -u github.com/golang/protobuf/protoc-gen-go
RUN git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout $GIT_TAG
RUN go install github.com/golang/protobuf/protoc-gen-go

RUN govendor sync &&\
    make pb

RUN go install ./server/... ./client/...

FROM alpine:3.7
RUN apk add --no-cache ca-certificates openvswitch sudo
WORKDIR /go/bin

COPY --from=0 /go/bin/server /go/bin
COPY --from=0 /go/bin/client /go/bin