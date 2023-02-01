FROM    golang:1.10-alpine

RUN     apk add -U python py-pip python-dev musl-dev gcc git bash
RUN     pip install pre-commit

ARG     METALINTER=v2.0.6
RUN     go get -d github.com/alecthomas/gometalinter && \
        cd /go/src/github.com/alecthomas/gometalinter && \
        git checkout -q "$METALINTER" && \
        go build -v -o /usr/local/bin/gometalinter . && \
        gometalinter --install && \
        rm -rf /go/src/* /go/pkg/*

WORKDIR /go/src/github.com/dnephin/dobi
COPY    .pre-commit-config.yaml ./
RUN     git init && pre-commit install-hooks

ENV     CGO_ENABLED=0
CMD     ["pre-commit", "run", "-a", "-v"]
