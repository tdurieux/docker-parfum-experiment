FROM node:16-alpine
LABEL maintainer="Carlos Justiniano cjus@ieee.org"
EXPOSE 80
ENV UV_THREADPOOL_SIZE 64
RUN apk add --update \
    curl \
  && rm -rf /var/cache/apk/*
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN npm install --production && npm cache clean --force;
CMD tail -f /dev/null
