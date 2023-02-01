#-------------------------------------------
# STEP 1 : build executable binary
#-------------------------------------------
FROM golang:1.16-alpine as builder

# gcc
RUN apk add --no-cache build-base

ADD . /usr/src/app

WORKDIR /usr/src/app

RUN GOOS=linux CGO_ENABLED=0 go build -ldflags '-w -extldflags "-static"' -tags cb-mcks -o cb-mcks -v src/main.go

#-------------------------------------------
# STEP 2 : build a image
#-------------------------------------------