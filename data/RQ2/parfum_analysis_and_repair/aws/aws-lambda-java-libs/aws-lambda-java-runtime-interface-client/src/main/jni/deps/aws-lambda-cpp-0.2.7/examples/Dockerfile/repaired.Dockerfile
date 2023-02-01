FROM alpine:latest

RUN apk update && apk add --no-cache cmake make git g++ bash curl-dev zlib-dev
