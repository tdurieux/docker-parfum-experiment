FROM golang:1.16.3-alpine

RUN apk --no-cache --update add make g++

COPY . /podium

WORKDIR /podium

ENTRYPOINT [ "/bin/sh", "-c", "make setup test" ]