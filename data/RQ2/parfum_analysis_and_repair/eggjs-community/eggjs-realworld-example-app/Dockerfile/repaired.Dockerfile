FROM node:8.11.1-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN npm i --production && npm cache clean --force;

# RUN npm i --production --registry=https://registry.npm.taobao.org

COPY . /usr/src/app

EXPOSE 7001

CMD npm run start