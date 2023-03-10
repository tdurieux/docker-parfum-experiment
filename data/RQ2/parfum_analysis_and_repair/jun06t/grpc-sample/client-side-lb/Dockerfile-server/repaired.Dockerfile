FROM golang:1.13-alpine

ARG REPO="github.com/jun06t/grpc-sample/client-side-lb"

RUN apk add --update --no-cache git
RUN mkdir -p /go/src/${REPO}
COPY . /go/src/${REPO}

WORKDIR /go/src/${REPO}

RUN cd server && go build && mv server /usr/local/bin

CMD ["server"]