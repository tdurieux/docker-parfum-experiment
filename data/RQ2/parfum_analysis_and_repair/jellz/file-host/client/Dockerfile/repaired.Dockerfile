FROM node:10-alpine

WORKDIR /usr/src/app

COPY yarn.lock ./
COPY package.json ./

RUN yarn && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

ENV PORT=3000
CMD [ "yarn", "serve" ]