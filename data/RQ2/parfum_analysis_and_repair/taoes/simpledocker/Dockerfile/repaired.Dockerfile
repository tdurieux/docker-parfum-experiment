# 网络问题导致构建失败，临时注释，有时间优化此问题

#FROM node:12-alpine AS ui-builder
#ARG HOST=127.0.0.1
#ARG PORT=9000
##ENV VUE_APP_API_HOST ${HOST}
#ENV VUE_APP_API_PORT ${PORT}
#WORKDIR /ui
#COPY ./ui/. .
#RUN npm install && \
#npm run build

#FROM golang:1.15-alpine AS api-builder
#WORKDIR /api
#COPY . .
#RUN export GOPROXY="https://mirrors.aliyun.com/goproxy/" && \
#export GO111MODULE=on && \
#apk --no-cache add gcc musl-dev && \
#go mod tidy && \
#go build -trimpath -o bin/SimpleDocker App.go && \
#chmod a+x bin/SimpleDocker