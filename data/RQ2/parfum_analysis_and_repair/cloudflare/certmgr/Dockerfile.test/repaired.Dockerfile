FROM golang:1.14-stretch
RUN mkdir -p $GOPATH/src/github.com/cloudflare/certmgr
COPY . $GOPATH/src/github.com/cloudflare/certmgr/
WORKDIR $GOPATH/src/github.com/cloudflare/certmgr