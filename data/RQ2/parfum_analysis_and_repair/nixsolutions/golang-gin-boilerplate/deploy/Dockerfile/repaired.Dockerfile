# base image
FROM golang:1.13.3-alpine3.10 as build

# install system utils
RUN apk add --no-cache --update git build-base openssh-client

# change workdir
WORKDIR /go/src/api

## read build arguments
ARG WEB_PRIVATE_KEY
ARG GIT_DOMAIN
#
## configuring ssh client
RUN mkdir ~/.ssh && \
    echo "$WEB_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa && \
    ssh-keyscan -H $GIT_DOMAIN >> ~/.ssh/known_hosts

# copy project
COPY . .

RUN  git config --global http.sslVerify true &&\
     # install swagger and initialize documentation
     go get -u github.com/pressly/goose/cmd/goose &&\
     go get -v github.com/swaggo/swag/cmd/swag &&\
     swag init &&\
     # install project dependecies
     go get -v ./... &&\
     # build application