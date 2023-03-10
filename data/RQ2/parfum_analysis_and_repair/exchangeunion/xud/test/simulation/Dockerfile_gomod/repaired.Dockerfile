FROM golang:1.11

ENV WD=/app
WORKDIR $WD

COPY go.mod .
COPY go.sum .

RUN GO111MODULE=on go get -d