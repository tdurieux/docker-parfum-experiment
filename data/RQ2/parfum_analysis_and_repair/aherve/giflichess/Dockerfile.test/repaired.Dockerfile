FROM golang:stretch
RUN mkdir /app
WORKDIR /app

ADD . .

RUN go get