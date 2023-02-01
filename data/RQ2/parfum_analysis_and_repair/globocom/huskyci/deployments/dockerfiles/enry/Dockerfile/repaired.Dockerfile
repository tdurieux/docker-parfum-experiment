# Dockerfile used to create "husyci/enry" image
# https://hub.docker.com/r/huskyci/enry/

FROM golang:alpine as builder

RUN apk update && apk upgrade \
	&& apk add --no-cache alpine-sdk bash make git 

RUN git clone https://github.com/src-d/enry.git && cd enry && make build 

# From the base image