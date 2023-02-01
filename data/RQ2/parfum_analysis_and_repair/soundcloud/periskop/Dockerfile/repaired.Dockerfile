## Build api
FROM golang:1.17.7 AS api-builder

WORKDIR /periskop

COPY go.mod .
COPY go.sum .
RUN /usr/local/go/bin/go mod download

COPY . .
RUN /usr/local/go/bin/go build -o app .

## Build web
FROM node:lts AS web-builder

WORKDIR /periskop
COPY . .
RUN npm ci --prefix web
RUN npm run build:dist --prefix web

## Build final container