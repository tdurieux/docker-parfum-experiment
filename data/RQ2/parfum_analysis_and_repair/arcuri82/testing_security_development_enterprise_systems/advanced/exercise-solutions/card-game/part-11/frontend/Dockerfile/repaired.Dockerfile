FROM node:12-alpine

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

CMD yarn start