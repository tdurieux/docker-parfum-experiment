FROM node:12.8.0-alpine

RUN apk add --update --no-cache alpine-sdk git python && \
  rm -rf /tmp/* /var/cache/apk/*

USER node

RUN mkdir /home/node/react
WORKDIR /home/node/react

COPY package.json package.json

ARG NPM_TOKEN

RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/.npmrc &&\
  npm i && \
  rm ~/.npmrc && npm cache clean --force;

COPY . /home/node/react/

EXPOSE 3001

CMD npm start
