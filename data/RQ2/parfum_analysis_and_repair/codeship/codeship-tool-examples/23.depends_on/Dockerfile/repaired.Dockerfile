FROM alpine:3.7

RUN apk add --no-cache --update curl

COPY ./wait.sh /wait.sh
