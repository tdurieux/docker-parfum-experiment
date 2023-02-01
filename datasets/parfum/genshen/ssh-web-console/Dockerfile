# build method: just run `docker build --rm --build-arg -t genshen/ssh-web-console .`

# build frontend code
FROM node:14.15.4-alpine3.12 AS frontend-builder

COPY web web-console/

RUN cd web-console \
    && yarn install \
    && yarn build


FROM golang:1.15.7-alpine3.13 AS builder

# set to 'on' if using go module
ARG STATIC_DIR=build


RUN apk add --no-cache git \
    && go get -u github.com/rakyll/statik

COPY ./  /go/src/github.com/genshen/ssh-web-console/
COPY --from=frontend-builder web-console/build /go/src/github.com/genshen/ssh-web-console/${STATIC_DIR}/

RUN cd ./src/github.com/genshen/ssh-web-console/ \
    && statik -src=${STATIC_DIR} \
    && go build \
    && go install

## copy binary
FROM alpine:3.13

ARG HOME="/home/web"

RUN adduser -D web -h ${HOME}

COPY --from=builder --chown=web /go/bin/ssh-web-console ${HOME}/ssh-web-console

WORKDIR ${HOME}
USER web

VOLUME ["${HOME}/conf"]

CMD ["./ssh-web-console"]
