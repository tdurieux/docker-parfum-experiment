FROM k0st/alpine-apache-php

LABEL maintainer "franzwagner.str@gmail.com"

# Change the TZ according to your region
ENV TZ=America/Sao_Paulo

RUN apk add --no-cache --update --virtual .build-deps tzdata && \
  ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
  echo "${TZ}" > /etc/timezone && \
  apk del .build-deps

COPY . /app
