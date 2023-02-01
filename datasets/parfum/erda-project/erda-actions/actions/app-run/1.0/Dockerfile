FROM registry.cn-hangzhou.aliyuncs.com/terminus/terminus-golang:1.16.7 AS builder

COPY . /go/src/github.com/erda-project/erda-actions
WORKDIR /go/src/github.com/erda-project/erda-actions

# go build
ENV GO111MODULE=on
RUN GOOS=linux GOARCH=amd64 go build -o /assets/run actions/app-run/1.0/internal/cmd/*.go
RUN GOOS=linux GOARCH=amd64 go build -o /assets/when_sigterm  actions/app-run/1.0/internal/appCancel/cmd/*.go

FROM registry.cn-hangzhou.aliyuncs.com/terminus/terminus-centos:base
COPY --from=builder /assets /opt/action
