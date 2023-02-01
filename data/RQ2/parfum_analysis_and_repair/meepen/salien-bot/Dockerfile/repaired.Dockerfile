FROM node:10-alpine

WORKDIR /app

COPY package.json /app

RUN yarn install && yarn cache clean;

COPY . /app

CMD ["node", "headless.js"]
