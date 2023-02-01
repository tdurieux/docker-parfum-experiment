FROM node:14

WORKDIR /opt

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn && yarn cache clean;

COPY . .

RUN yarn build:app:node && yarn cache clean;

RUN npm i -g . && npm cache clean --force;
