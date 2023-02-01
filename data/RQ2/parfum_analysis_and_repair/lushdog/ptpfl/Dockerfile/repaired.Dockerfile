FROM node:14.15.4-slim

ENV NODE_ENV=production
ENV RUN_ENV=docker

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

CMD ["node", "index.js"]
