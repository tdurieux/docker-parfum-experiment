FROM golang:1.12-alpine

ADD . /go/src/app
WORKDIR /go/src/app

CMD ["go", "run", "main.go"]
