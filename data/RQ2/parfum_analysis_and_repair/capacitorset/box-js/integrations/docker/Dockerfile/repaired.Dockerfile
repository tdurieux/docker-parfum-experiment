FROM node:8-alpine
RUN apk update && apk upgrade
RUN apk add --no-cache file gcc m4
RUN apk add --no-cache -U --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing aufs-util
RUN npm install box-js --global --production && npm cache clean --force;
WORKDIR /samples
CMD box-js /samples --output-dir=/samples --loglevel=debug
