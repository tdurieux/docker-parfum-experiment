FROM golang:1.18
LABEL MAINTAINER yunlong <zhenmu.zyl@alibaba-inc.com>
# Install go debugger
RUN GO111MODULE=off go get -u github.com/go-delve/delve/cmd/dlv

FROM registry.cn-hangzhou.aliyuncs.com/rdc-incubator/kt-connect-shadow:latest
COPY --from=0 /go/bin/dlv /usr/sbin/dlv
CMD ["--debug"]