FROM golang:1.14.2-buster

RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN go get golang.org/x/tools/cmd/stringer

ADD . /go/src/github.com/harrybrwn/apizza
WORKDIR /go/src/github.com/harrybrwn/apizza

RUN make install

ENTRYPOINT ["apizza"]
