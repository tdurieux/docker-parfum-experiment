FROM golang:1.8-alpine3.6

RUN apk --update --no-cache add \
    git openssl \
    && rm /var/cache/apk/*

WORKDIR /go/src

ADD . /go/src

RUN go-wrapper download

CMD ["go", "run", "main.go", "server.go"]

EXPOSE 3000