## Build server
FROM golang:1.13-alpine AS build-backend
ADD ./main.go /go/src/github.com/Roverr/rtsp-stream/main.go
ADD ./core /go/src/github.com/Roverr/rtsp-stream/core
ADD ./Gopkg.toml /go/src/github.com/Roverr/rtsp-stream/Gopkg.toml
WORKDIR /go/src/github.com/Roverr/rtsp-stream
RUN apk add --update --no-cache git
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -v
RUN go build -o server

## Build UI
FROM node:lts-slim as build-ui
ADD ./ui /tmp/ui
WORKDIR /tmp/ui
RUN npm install && npm cache clean --force;
RUN echo API_URL=http://127.0.0.1:8080 > ./src/.env
RUN npm run build

## Creating potential production image
FROM woahbase/alpine-supervisor:x86_64
RUN apk update && apk add bash ca-certificates ffmpeg nodejs npm && rm -rf /var/cache/apk/*
RUN npm install http-server -g && npm cache clean --force;
COPY ./build/management/supervisord.conf /etc/supervisord.conf
WORKDIR /app
COPY --from=build-backend /go/src/github.com/Roverr/rtsp-stream/server /app/
COPY ./build/rtsp-stream.yml /app/rtsp-stream.yml
COPY --from=build-ui /tmp/ui/dist /ui/
