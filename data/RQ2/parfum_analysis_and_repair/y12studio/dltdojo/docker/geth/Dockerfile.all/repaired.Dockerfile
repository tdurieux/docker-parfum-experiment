FROM golang:1.9-alpine
# FROM alpine:3.6
# https://github.com/docker-library/golang/blob/master/1.9-rc/alpine/Dockerfile
ENV ETHGO_VERSION=1.6.6
RUN apk --update --no-cache add curl build-base musl-dev linux-headers \
    && curl -f --insecure -sL https://github.com/ethereum/go-ethereum/archive/v$ETHGO_VERSION.tar.gz | tar zx \
    && mv go-ethereum-$ETHGO_VERSION go-ethereum \
    && (cd go-ethereum && make all)
#  dltdojo/geth:1.6.6.all
FROM alpine:3.6
COPY --from=0 /go/go-ethereum/build/bin/* /usr/local/bin/
RUN apk --update --no-cache add bash curl jq
WORKDIR /opt/geth
ENTRYPOINT []
CMD ["geth","--dev","--rpc","--rpcapi", "miner,admin,db,personal,eth,net,web3"]