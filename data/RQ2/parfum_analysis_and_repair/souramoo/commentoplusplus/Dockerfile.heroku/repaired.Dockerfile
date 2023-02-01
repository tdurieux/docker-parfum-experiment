# vim: syntax=dockerfile
## Commento Dockerfile for running on Heroku

# 1. duplicate most of original docker image: https://gitlab.com/commento/commento/blob/master/Dockerfile
# backend build (api server)
FROM golang:1.15-alpine AS api-build
RUN apk add --no-cache --update bash make git curl

COPY ./api /go/src/commento/api/
WORKDIR /go/src/commento/api
ENV GO111MODULE=on
RUN make prod -j$(($(nproc) + 1))


# frontend build (html, js, css, images)
FROM node:12-alpine AS frontend-build
RUN apk add --no-cache --update bash make

COPY ./frontend /commento/frontend
WORKDIR /commento/frontend/
RUN make prod -j$(($(nproc) + 1))


# templates and db build
FROM alpine:3.12 AS templates-db-build
RUN apk add --no-cache --update bash make

COPY ./templates /commento/templates
WORKDIR /commento/templates
RUN make prod -j$(($(nproc) + 1))

COPY ./db /commento/db
WORKDIR /commento/db
RUN export COMMENTO_POSTGRES=$(DATABASE_URL)   # our addition
RUN make prod -j$(($(nproc) + 1))


# final image