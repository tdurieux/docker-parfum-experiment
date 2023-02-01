FROM node:10-alpine

WORKDIR /usr/src/app

COPY yarn.lock ./
COPY package.json ./

RUN yarn && yarn cache clean;

COPY . .

CMD [ "yarn", "start" ]