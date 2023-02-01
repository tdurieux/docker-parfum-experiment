FROM golang:1.18 as fedbox-builder

ENV GO111MODULE=on

ADD ./ /go/src/app

WORKDIR /go/src/app
RUN make download && go mod vendor