# Builder image
FROM golang:1.17-alpine as builder

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories && \
    apk add --no-cache \
    wget \
    git

RUN mkdir -p /home/build && \
    mkdir -p /home/scheduler

ARG build_dir=/home/build
ARG scheduler_dir=/home/scheduler

ENV ServiceName=gf.bridgx.scheduler

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
COPY wait-for-scheduler.sh output/bin/wait-for-scheduler.sh

RUN find conf/ -type f ! -name "*local*" -print0 | xargs -0 -I{} cp {} output/conf/
RUN cp scripts/run_scheduler.sh output/

RUN CGO_ENABLED=0 GO111MODULE=on go build -o output/bin/${ServiceName} ./cmd/scheduler

RUN cp -rf output/* $scheduler_dir

# --------------------------------------------------------------------------------- #
# Executable image