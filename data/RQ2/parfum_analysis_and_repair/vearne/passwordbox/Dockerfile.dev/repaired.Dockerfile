FROM golang:1.16

RUN apt-get update && apt-get install --no-install-recommends vim-common -y && rm -rf /var/lib/apt/lists/*;


WORKDIR /go/src/github.com/vearne/passwordbox/
ADD . /go/src/github.com/vearne/passwordbox/

RUN go get
