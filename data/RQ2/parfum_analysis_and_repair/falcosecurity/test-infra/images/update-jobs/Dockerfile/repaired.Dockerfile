# --- Args ---

ARG GOVERSION=1.15.7-alpine
ARG GOPATH=/go
ARG APP_NAME=update-jobs

# --- Build ---

FROM golang:$GOVERSION as builder

ARG GOPATH
ARG APP_NAME

RUN apk --no-cache add \
	make \
	bash

WORKDIR ${GOPATH}/src/${APP_NAME}

COPY go.mod .
COPY go.sum .
COPY main.go .
COPY Makefile .

RUN OUTPUT_BASE=${GOPATH} make build

# --- Final ---