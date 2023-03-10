FROM golang:1.14.3 AS build

WORKDIR /go/src/github.com/HYmian/gin-sample

ADD ./ ./

RUN go install -mod vendor -v

FROM centos:7.5.1804

WORKDIR /var/local/bin

COPY --from=build /go/bin/gin-sample .

CMD ["./gin-sample", "-logtostderr", "-v", "2"]