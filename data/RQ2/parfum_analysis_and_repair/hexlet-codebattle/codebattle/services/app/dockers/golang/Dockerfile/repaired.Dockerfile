FROM golang:1.17-alpine

RUN apk add --no-cache --update make

WORKDIR /usr/src/app

ADD checker_example.go .
ADD solution_example.go .
ADD Makefile .
