# bilicoin service Dockerfile
# version 1.1.2
# author r3inbowari
FROM golang:1.17.2 as builder
LABEL stage="builder"

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /app

COPY . .

# use netgo