FROM alpine:latest

RUN apk update && apk add --no-cache --update curl

COPY ./checkip /
ENTRYPOINT ["./checkip"]
