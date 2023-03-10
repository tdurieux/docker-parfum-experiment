FROM golang:1.15.2-alpine

MAINTAINER TFG Co <backend@tfgco.com>

RUN apk update
RUN apk add --no-cache git make g++ apache2-utils
RUN apk add --no-cache --update bash

RUN go get -u github.com/golang/dep/...

ADD . /go/src/github.com/topfreegames/khan

WORKDIR /go/src/github.com/topfreegames/khan
RUN go mod tidy
RUN go install github.com/topfreegames/khan

ENV KHAN_POSTGRES_HOST 0.0.0.0
ENV KHAN_POSTGRES_PORT 5432
ENV KHAN_POSTGRES_USER khan
ENV KHAN_POSTGRES_PASSWORD ""
ENV KHAN_POSTGRES_DBNAME khan
ENV KHAN_PRUNING_SLEEP 3600

CMD /bin/bash -lc 'while true; do /go/bin/khan prune --config /go/src/github.com/topfreegames/khan/config/default.yaml; sleep $KHAN_PRUNING_SLEEP; done'
