FROM node:14-alpine

LABEL maintainer="bananaprotocol@protonmail.com"

WORKDIR /usr/share/app

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV BOT_TOKEN=
ENV FINNHUB_API_KEY=

CMD ["npm", "start"]
