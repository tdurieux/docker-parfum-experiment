# syntax=docker/dockerfile:1

## Build
FROM golang:1.17-bullseye as build

WORKDIR /anone
COPY . /anone
RUN make install

## Deploy