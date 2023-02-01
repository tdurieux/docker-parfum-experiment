FROM node:14-alpine

RUN mkdir /fake-log
WORKDIR /fake-log

RUN apk add --no-cache git python2 make g++

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
