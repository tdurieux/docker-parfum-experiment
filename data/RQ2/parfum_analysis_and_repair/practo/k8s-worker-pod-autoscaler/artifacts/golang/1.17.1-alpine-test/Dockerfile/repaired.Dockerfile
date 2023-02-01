FROM golang:1.17.1-alpine

RUN apk add --no-cache beanstalkd
