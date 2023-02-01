FROM node:alpine

RUN apk add --no-cache \
	git

RUN npm install -g \
	bower \
	gulp && npm cache clean --force;

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN npm install && npm cache clean --force;
RUN bower install --allow-root
