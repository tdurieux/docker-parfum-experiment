FROM node:11-alpine as codebuilder
WORKDIR /app
RUN apk add --no-cache bash
RUN apk --update add python3
RUN apk add --no-cache --virtual build-base
RUN apk add --no-cache --virtual curl
RUN apk add --no-cache --virtual jq

RUN apk update
RUN apk add bash py3-pip
RUN apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make
RUN pip3 --no-cache-dir install -U pip
RUN pip3 --no-cache-dir install azure-cli
RUN apk del --purge build

MAINTAINER Andrew Schmidt (https://github.com/andrewschmidt-a)

LABEL Tags="Azure,IoT,Solutions,React,SPA"

RUN echo "Installing web server..." \
 && apk add --no-cache nginx \
 && mkdir /app/logs \
 && mkdir -p /var/lib/nginx /var/cache/nginx /var/tmp/nginx /var/log/nginx \
 && echo "Removing unused files..." \
 && apk del --force --purge alpine-keys apk-tools \
 && rm -rf /var/cache/apk /etc/apk /lib/apk

EXPOSE 10080
RUN touch /app/logs/error.log
WORKDIR /app
COPY ./set_env.sh .

RUN chmod +x ./set_env.sh
COPY ./run.sh .
RUN chmod +x ./run.sh
COPY ./content/nginx.conf /app/nginx.conf
ENTRYPOINT [ "/app/run.sh" ]