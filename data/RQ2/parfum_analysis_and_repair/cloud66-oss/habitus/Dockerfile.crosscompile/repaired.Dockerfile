#use the golang base image
FROM golang:1.12
MAINTAINER Daniël van Gils

RUN go get github.com/mitchellh/gox

#copy the source files
RUN mkdir -p /usr/local/go/src/github.com/cloud66-oss/habitus
COPY . /usr/local/go/src/github.com/cloud66-oss/habitus

#switch to our app directory