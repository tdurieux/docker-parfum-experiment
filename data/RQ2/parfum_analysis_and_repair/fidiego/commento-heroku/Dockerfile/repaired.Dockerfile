# backend build (api server)
FROM golang:1.14-alpine AS api-build
RUN apk add --no-cache --update bash dep make git curl g++

COPY ./api /go/src/commento/api/
WORKDIR /go/src/commento/api
RUN make prod -j$(($(nproc) + 1))


# frontend build (html, js, css, images)
FROM node:10-alpine AS frontend-build
RUN apk add --no-cache --update bash make python2 g++

COPY ./frontend /commento/frontend
WORKDIR /commento/frontend/
RUN make prod -j$(($(nproc) + 1))


# templates and db build
FROM alpine:3.9 AS templates-db-build
RUN apk add --no-cache --update bash make

COPY ./templates /commento/templates
WORKDIR /commento/templates
RUN make prod -j$(($(nproc) + 1))

COPY ./db /commento/db
WORKDIR /commento/db
RUN make prod -j$(($(nproc) + 1))


# final image