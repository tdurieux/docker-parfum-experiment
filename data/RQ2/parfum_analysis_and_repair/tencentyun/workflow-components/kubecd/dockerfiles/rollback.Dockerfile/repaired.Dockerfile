FROM golang:1.10-alpine as builder

MAINTAINER foxzhong@tencent.com
WORKDIR /go/src/kubecd

COPY ./ /go/src/kubecd

RUN set -ex && go build -v -o /go/bin/kubecd -gcflags '-N -l' ./*.go

FROM roffe/kubectl
COPY --from=builder /go/bin/kubecd /usr/bin/
ENV ACTION rollback
CMD ["kubecd"]

LABEL TencentHubComponent='{\
  "description": "TencentHub 基于kubernetes 持续部署组件: 滚回操作",\
  "input": [\
    {"name": "USERNAME", "desc": "必填，kubernetes 用户名"},\
    {"name": "PASSWORD", "desc": "必填，kubernetes 用户密码"},\
    {"name": "CERTIFICATE", "desc": "必填, kubernetes 证书内容"},\
    {"name": "SERVER", "desc": "必填, kubernetes 服务器地址"},\

    {"name": "DEPLOY_GROUP", "desc": "必填, 目标部署组"},\
    {"name": "FROM_DEPLOY_TARGET", "desc": "可选, 回滚源部署版本游标"},\
    {"name": "FROM_DEPLOYMENT_NAME", "desc": "可选, 回滚源部署版本名称"},\
    {"name": "TO_DEPLOY_TARGET", "desc": "可选, 回滚目标部署版本游标"},\
    {"name": "TO_DEPLOYMENT_NAME", "desc": "可选, 回滚目标部署版本名称"}\
  ],\
  "output": [\
  ]\
}'