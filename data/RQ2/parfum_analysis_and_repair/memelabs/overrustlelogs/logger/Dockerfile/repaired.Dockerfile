# build stage
FROM golang:1.16-alpine AS build-env
RUN apk --no-cache add build-base git mercurial gcc
ADD . /src
RUN cd /src && go get -v . && go build -o orl-logger

# final stage