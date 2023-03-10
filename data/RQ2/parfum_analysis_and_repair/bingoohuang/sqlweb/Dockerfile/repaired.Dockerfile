##
# First Build
#
##
FROM golang:1.11.1-alpine AS builder
ENV GO111MODULE on
COPY . /go/src/github.com/bingoohuang/go-sql-web/
WORKDIR /go/src/github.com/bingoohuang/go-sql-web/

RUN set -x \
	echo 'http://mirrors.aliyun.com/alpine/v3.8/community/' > /etc/apk/repositories \
	&& echo 'http://mirrors.aliyun.com/alpine/v3.8/main/' >> /etc/apk/repositories \
	&& apk add --no-cache --virtual .build-deps git build-base curl \
	&& git config --global http.sslVerify true \
	&& go mod tidy \
	&& GOOS=linux GOARCH=amd64 go build -a -o app . \
	&& apk del .build-deps
##
# Second
#
##