FROM node:14.16-slim

WORKDIR /app

RUN yarn global add pm2 -g

COPY package.json yarn.lock /app/

RUN yarn install && yarn cache clean;

COPY . /app

CMD ./start