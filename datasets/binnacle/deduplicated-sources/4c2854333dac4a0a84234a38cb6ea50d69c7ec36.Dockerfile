FROM alpine:3.7

RUN apk add --update curl

COPY ./wait.sh /wait.sh
