FROM node:14-alpine

# curl needed to display Heroku release logs
RUN apk --no-cache add curl

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . /app
COPY .env.example /app/.env

RUN yarn build

CMD yarn start:prod
