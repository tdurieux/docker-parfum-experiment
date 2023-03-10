FROM golang:1.13-alpine

ARG REPO="github.com/jun06t/grpc-sample/client-side-lb"

RUN apk add --update --no-cache git
RUN mkdir -p /go/src/${REPO}
COPY . /go/src/${REPO}

WORKDIR /go/src/${REPO}

RUN cd client && go build && mv client /usr/local/bin

CMD ["client"]