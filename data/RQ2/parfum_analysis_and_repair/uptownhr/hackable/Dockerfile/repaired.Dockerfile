FROM node:10-alpine

ADD ./ /api

WORKDIR /api

RUN yarn && yarn cache clean;

EXPOSE "3000"

CMD node index.js