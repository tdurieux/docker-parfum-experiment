# Build-time variables
ARG RELEASE=prod
ARG ALPINE_VERSION=3.15
ARG GOLANG_VERSION=1.15
ARG NODE_VERSION=16

# backend build (api server)
FROM golang:${GOLANG_VERSION}-alpine AS api-build
RUN apk add --no-cache bash dep make git curl g++

ARG RELEASE
COPY ./api /go/src/commento/api/
WORKDIR /go/src/commento/api
RUN make ${RELEASE} -j$(($(nproc) + 1))


# frontend build (html, js, css, images)
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS frontend-build
RUN apk add --no-cache bash make python2 g++

ARG RELEASE
COPY ./frontend /commento/frontend
WORKDIR /commento/frontend/
RUN make ${RELEASE} -j$(($(nproc) + 1))


# templates and db build
FROM alpine:${ALPINE_VERSION} AS templates-db-build
RUN apk add --no-cache bash make

ARG RELEASE
COPY ./templates /commento/templates
WORKDIR /commento/templates
RUN make ${RELEASE} -j$(($(nproc) + 1))

COPY ./db /commento/db
WORKDIR /commento/db
RUN make ${RELEASE} -j$(($(nproc) + 1))


# final image