FROM node:12

RUN mkdir /app

ADD ./src/frontend/package.json /app/.
ADD ./src/frontend/yarn.lock /app/.

WORKDIR /app

RUN yarn && yarn cache clean;
