# Build the manager binary
FROM golang:1.13.10-alpine3.11

RUN apk add --no-cache --update curl tzdata iproute2 bash libc6-compat vim && \
  rm -rf /var/cache/apk/* && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" >  /etc/timezone

WORKDIR /go/src/github.com/Alluxio/alluxio
COPY . .

RUN go get github.com/go-delve/delve/cmd/dlv

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=off

CMD ["dlv", "debug", "--headless", "--listen", "':12345'", "--log", "--api-version=2", "cmd/controller/main.go"]

