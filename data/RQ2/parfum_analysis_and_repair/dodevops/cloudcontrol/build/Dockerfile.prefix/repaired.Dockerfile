FROM node:lts as cccClientBuild

WORKDIR /build
COPY ccc/client /build
RUN npm install && npm cache clean --force;
RUN npm run-script build

FROM golang:1.14.6 AS cccBuild

WORKDIR /build
COPY ccc/go.mod /build
COPY ccc/ccc.go /build
RUN go build ccc.go
