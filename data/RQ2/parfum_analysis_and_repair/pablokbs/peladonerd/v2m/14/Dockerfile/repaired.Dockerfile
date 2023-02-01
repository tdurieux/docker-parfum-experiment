FROM python:3.8-alpine

RUN apk add --no-cache --update vim

WORKDIR /usr/src/myapp

COPY . .

ENTRYPOINT [ "python" ]
