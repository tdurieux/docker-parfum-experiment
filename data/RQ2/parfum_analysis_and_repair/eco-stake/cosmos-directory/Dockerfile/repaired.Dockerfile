FROM node:17-alpine

RUN apk update && apk add --no-cache git

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
RUN npm install pm2 -g && npm cache clean --force;
COPY . ./

EXPOSE 3000

ENV NODE_ENV=production
ENV APP_NAME=app

CMD pm2-runtime ecosystem.${NODE_ENV}.json --only ${APP_NAME}