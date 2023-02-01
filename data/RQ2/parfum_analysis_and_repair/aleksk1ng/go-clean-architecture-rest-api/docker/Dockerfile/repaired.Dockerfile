# Initial stage: download modules
FROM golang:1.16-alpine as builder

ENV config=docker

WORKDIR /app

COPY ./ /app

RUN go mod download


# Intermediate stage: Build the binary