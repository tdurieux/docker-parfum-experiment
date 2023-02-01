FROM golang:latest

WORKDIR $GOPATH/src/github.com/owenthereal/upterm
COPY . .
ENV GOOS=linux GOARCH=amd64

RUN make ftest