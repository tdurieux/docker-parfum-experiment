# base image
FROM node:13.10.1-alpine
RUN apk add --no-cache --update bash git yarn && rm -rf /var/cache/apk/*
ADD frontend/run .
