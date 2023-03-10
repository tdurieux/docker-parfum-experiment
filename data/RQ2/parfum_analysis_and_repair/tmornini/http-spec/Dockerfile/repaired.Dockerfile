FROM golang:alpine
MAINTAINER Tom Mornini <tmornini@incentivenetworks.com>

RUN apk update && \
    apk add --no-cache bash && \
    apk add --no-cache git

COPY * /go/src/github.com/tmornini/http-spec/

RUN cd /go/src/github.com/tmornini/http-spec && \
    go install .

WORKDIR /

CMD ["/run-http-specs"]
