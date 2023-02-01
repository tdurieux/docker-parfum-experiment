#
# Dockerfile
#
# @author yihao.peng@bitmain.com
# @copyright btc.com
# @since 2019-10-09
#
#
FROM golang as build
LABEL maintainer="Yihao Peng <yihao.peng@bitmain.com>"

COPY get_eth_header.go /work/get_eth_header/get_eth_header.go
RUN go get github.com/go-sql-driver/mysql && \
    go get github.com/golang/glog && \
    go get github.com/gorilla/websocket && \
    cd /work/get_eth_header && go build

######### Release image #########