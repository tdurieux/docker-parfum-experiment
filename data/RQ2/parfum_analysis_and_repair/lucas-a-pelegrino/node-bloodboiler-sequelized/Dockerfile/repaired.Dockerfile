FROM node:lts-alpine3.12

RUN npm i npm@latest -g && npm cache clean --force;

RUN mkdir /opt/node_app && chown node:node /opt/node_app
WORKDIR /opt/node_app

USER node

COPY package.json package-lock.json* ./

RUN npm install && npm cache clean --force

ENV PATH /opt/node_app/node_modules/.bin:$PATH

WORKDIR /opt/node_app/app

COPY . .

EXPOSE 3000