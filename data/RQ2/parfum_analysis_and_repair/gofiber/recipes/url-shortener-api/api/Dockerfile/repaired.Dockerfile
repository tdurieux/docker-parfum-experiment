# multistage docker build. This redices the size of the final docker image.
# stage 1 to build the app
FROM golang:alpine as builder

RUN mkdir /build 

ADD . /build/

WORKDIR /build 

RUN go build -o main .

# stage 2 deploys the app built in stage 1