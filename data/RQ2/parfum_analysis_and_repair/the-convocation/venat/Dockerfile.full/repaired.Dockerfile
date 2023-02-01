FROM node:16-alpine

WORKDIR /usr/src/app

COPY . .

RUN yarn install && yarn cache clean;
RUN yarn build

CMD yarn start
