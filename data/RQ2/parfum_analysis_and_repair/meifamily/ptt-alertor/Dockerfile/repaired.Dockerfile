# building binary
FROM golang:1.15-alpine as builder

ENV GOPATH /go/
ENV GO_WORKDIR $GOPATH/src/github.com/Ptt-Alertor/ptt-alertor/
ENV GO111MODULE=on
ENV CGO_ENABLED=0

WORKDIR $GO_WORKDIR

ADD . $GO_WORKDIR

RUN go get
RUN go install

# building executable image