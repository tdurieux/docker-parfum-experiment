# backend build (api server)
FROM golang:1.15-alpine AS api-build
RUN apk add --no-cache --update bash dep make git curl g++

ARG RELEASE=prod
COPY ./api /go/src/commento/api/
WORKDIR /go/src/commento/api
RUN make ${RELEASE} -j$(($(nproc) + 1))


# frontend build (html, js, css, images)
FROM node:12-alpine AS frontend-build
RUN apk add --no-cache --update bash make python2 g++

ARG RELEASE=prod
COPY ./frontend /commento/frontend
WORKDIR /commento/frontend/
RUN make ${RELEASE} -j$(($(nproc) + 1))


# templates and db build
FROM alpine:3.13 AS templates-db-build
RUN apk add --no-cache --update bash make

ARG RELEASE=prod
COPY ./templates /commento/templates
WORKDIR /commento/templates
RUN make ${RELEASE} -j$(($(nproc) + 1))

COPY ./db /commento/db
WORKDIR /commento/db
RUN make ${RELEASE} -j$(($(nproc) + 1))


# final image