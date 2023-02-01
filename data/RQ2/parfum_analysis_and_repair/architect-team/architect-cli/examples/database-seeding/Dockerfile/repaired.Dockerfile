FROM node:12-alpine

WORKDIR /usr/src/app

RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npx tsc

CMD [ "npm", "start" ]
