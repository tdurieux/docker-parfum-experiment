FROM node:lts-alpine

RUN apk add --no-cache bash
RUN apk add --no-cache git

RUN mkdir /game_rps
RUN mkdir /game_rps/client
WORKDIR /game_rps

ADD game_engine ./game_engine

ADD client/src ./client/src
ADD client/webpack ./client/webpack
ADD client/package.json ./client
ADD client/index.html ./client
ADD client/.babelrc ./client

WORKDIR client
RUN npm update
RUN npm install && npm cache clean --force;

CMD npm run start