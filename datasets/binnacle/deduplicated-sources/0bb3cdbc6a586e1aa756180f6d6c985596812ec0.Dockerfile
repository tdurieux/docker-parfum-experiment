FROM golang:1.12.1-alpine

RUN apk add git

ENV CGO_ENABLED=0 GO111MODULE=on

WORKDIR /go/src/github.com/sensiblecodeio/hookbot

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go install -v

EXPOSE 8080

USER nobody:nogroup
ENTRYPOINT ["hookbot"]
