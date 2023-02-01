# builder
FROM golang:latest AS builder

RUN mkdir /app
ADD . /app
COPY . /app
WORKDIR /app

RUN go get
RUN go build


# runner