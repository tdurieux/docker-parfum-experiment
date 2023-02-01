FROM node:alpine

WORKDIR /app

COPY . ./

RUN yarn install && yarn cache clean;
RUN yarn build
RUN yarn lint
RUN yarn test && yarn cache clean;
