FROM python:3.7-alpine3.10 as alpine

RUN apk add -U --no-cache ca-certificates
ENTRYPOINT []
WORKDIR /