FROM golang:alpine

WORKDIR /server

COPY run-dev.sh run-dev.sh

RUN chmod 777 run-dev.sh

RUN apk add --no-cache git gcc libc-dev \
    && go get -u -v github.com/cosmtrek/air \
    && apk add --no-cache build-base

COPY . .

CMD ["air"]
