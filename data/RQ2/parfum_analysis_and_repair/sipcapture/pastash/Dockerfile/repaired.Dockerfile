# PaStash Docker Example
FROM node:14-slim

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

RUN mkdir -p /config

EXPOSE 8080
CMD [ "bin/pastash", "--config_dir", "/config" ]

