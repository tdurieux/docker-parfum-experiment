# Build Image for BOtB
FROM golang:alpine AS build-env

RUN apk --no-cache add build-base git bzr mercurial gcc
WORKDIR /src
RUN git clone https://github.com/brompwnie/botb.git
RUN cd /src/botb && go build -o botb -ldflags "-linkmode external -extldflags -static"

# Image: nodyd/botb