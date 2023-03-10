FROM golang:1.14-alpine

RUN apk add --no-cache make gcc musl-dev linux-headers git

ENV GO111MODULE=on

COPY . /go-ethereum
RUN cd /go-ethereum && go run build/ci.go install

COPY docker/test_entrypoint.sh /bin
RUN chmod +x /bin/test_entrypoint.sh

ENTRYPOINT ["sh", "/bin/test_entrypoint.sh"]