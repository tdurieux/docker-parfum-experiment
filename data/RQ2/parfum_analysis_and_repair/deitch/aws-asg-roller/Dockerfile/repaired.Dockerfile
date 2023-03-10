# base golang image
ARG GOVER="1.15.6-alpine3.12"
FROM golang:${GOVER} as golang

ARG REPO

RUN apk add -U --no-cache git ca-certificates

RUN GO111MODULE=off go get -u golang.org/x/lint/golint

ENV GO111MODULE=on 
ENV CGO_ENABLED=0

WORKDIR /go/src/${REPO}

COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .

# these have to be last steps so they do not bust the cache with each change
ARG OS
ARG ARCH
ENV GOOS=${OS} 
ENV GOARCH=${ARCH} 

# builder