FROM golang:1.12.4-alpine

ARG git_tag
ARG git_commit

RUN apk add --no-cache git build-base

WORKDIR /go/src/github.com/ory/hydra

ENV GO111MODULE=on

ADD . .

RUN go install .
RUN go build -buildmode=plugin -o /memtest.so ./test/e2e/plugin/memtest.go

ENTRYPOINT ["hydra"]

CMD ["serve", "all"]
