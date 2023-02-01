FROM golang:alpine

RUN apk update && apk add --no-cache git

RUN go get github.com/alash3al/lightify

ENTRYPOINT ["lightify"]

WORKDIR /root/