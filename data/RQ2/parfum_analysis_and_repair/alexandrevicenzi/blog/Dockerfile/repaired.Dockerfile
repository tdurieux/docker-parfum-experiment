FROM alpine:latest

RUN apk add --no-cache hugo

USER 1000:1000
