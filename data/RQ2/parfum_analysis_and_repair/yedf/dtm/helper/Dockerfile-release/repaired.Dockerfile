# syntax=docker/dockerfile:1
# FROM node:14.19-alpine as builder1
# ARG RELEASE_VERSION
# WORKDIR /app/dtm
# COPY . .
# RUN cd admin && yarn && VITE_ADMIN_VERSION=$RELEASE_VERSION yarn build

FROM --platform=$TARGETPLATFORM golang:1.16-alpine as builder2
ARG TARGETARCH
ARG TARGETOS
ARG RELEASE_VERSION
WORKDIR /app/dtm
# RUN go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
EXPOSE 8080
COPY . .
# COPY --from=builder1 /app/dtm/admin/dist /app/dtm/admin