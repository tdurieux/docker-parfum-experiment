FROM node:alpine

LABEL maintainer="yotta.dev<team@yotta.dev>"

RUN mkdir /app
WORKDIR /app

COPY package.json .
RUN yarn && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;
CMD ["yarn", "start:prod"]
