FROM golang:1.13

RUN go get -d -v github.com/dedis/prifi/sda/app

WORKDIR $GOPATH/src/github.com/dedis/prifi

CMD ["make", "all"]
