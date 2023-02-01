# Builder image
FROM golang:1.17-alpine as builder

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories && \
    apk add --no-cache \
    wget \
    git

RUN mkdir -p /home/build && \
    mkdir -p /home/api

ARG build_dir=/home/build
ARG api_dir=/home/api

ENV ServiceName=gf.bridgx.api

WORKDIR $build_dir

COPY . .

# Cache dependencies
ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn,direct

COPY go.mod go.mod
COPY go.sum go.sum
#RUN  go mod download

RUN mkdir -p output/conf output/bin

# detect mysql start
COPY wait-for-api.sh output/bin/wait-for-api.sh

RUN find conf/ -type f ! -name "*local*" -print0 | xargs -0 -I{} cp {} output/conf/
RUN cp scripts/run_api.sh output/

RUN CGO_ENABLED=0 GO111MODULE=on go build -o output/bin/${ServiceName} ./cmd/api

RUN cp -rf output/* $api_dir

# --------------------------------------------------------------------------------- #
# Executable image