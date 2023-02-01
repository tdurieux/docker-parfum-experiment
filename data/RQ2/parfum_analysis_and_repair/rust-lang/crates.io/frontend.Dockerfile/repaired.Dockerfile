FROM node:16.16.0-alpine

WORKDIR /app
COPY package.json yarn.lock /app/

RUN yarn install && yarn cache clean;

COPY . /app

ENTRYPOINT ["yarn", "start:staging"]
