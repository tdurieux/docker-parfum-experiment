FROM golang:1.11.2-alpine3.7

RUN apk update && apk upgrade && cd $GOPATH && apk add --no-cache git && apk add --no-cache build-base && apt add make && apk add --no-cache bash && \
    go get github.com/torusresearch/torus && mkdir $GOPATH/src/github.com/tendermint && cd $GOPATH/src/github.com/tendermint && \
    git clone https://github.com/torusresearch/tendermint && cd $GOPATH/src/github.com/torusresearch/tendermint && \
    make get_tools && make get_vendor_deps \
    wget https://github.com/google/leveldb/archive/v1.20.tar.gz && \
    tar -zxvf v1.20.tar.gz && \
    cd leveldb-1.20/ && \
    make && \
    cp -r out-static/lib* out-shared/lib* /usr/local/lib/ && \
    cd include/ && \
    cp -r leveldb /usr/local/include/ && \
    ldconfig && \
    rm -f v1.20.tar.gz && cd $GOPATH/src/github.com/torusresearch/torus




