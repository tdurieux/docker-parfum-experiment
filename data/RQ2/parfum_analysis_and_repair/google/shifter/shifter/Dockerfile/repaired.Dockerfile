# syntax=docker/dockerfile:1

##
## Build Shifter Server
##
FROM golang:1.18.1 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

ADD . ./

RUN go build -o /shifter

##
## Deploy Shifter Server
##