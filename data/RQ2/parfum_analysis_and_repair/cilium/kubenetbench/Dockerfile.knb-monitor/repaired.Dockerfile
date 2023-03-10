FROM golang:alpine as builder
RUN apk add --no-cache --update make git protoc

RUN go get -u github.com/spf13/cobra
RUN go get -u github.com/golang/protobuf/proto
RUN go get -u google.golang.org/grpc

ADD . /go/src/github.com/cilium/kubenetbench
WORKDIR /go/src/github.com/cilium/kubenetbench
RUN make benchmonitor/srv/srv

FROM alpine
RUN apk add --no-cache --update perf jq
COPY --from=builder /go/src/github.com/cilium/kubenetbench/benchmonitor/srv/srv /monitor-srv

RUN mkdir /scripts
COPY /scripts/system_info.sh /scripts/
COPY /scripts/perf* /scripts/

CMD ["./monitor-srv"]
