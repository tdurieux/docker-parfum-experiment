FROM node:8.12.0-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV production

COPY packages/server/package.json /usr/src/app
RUN yarn install --non-interactive

COPY packages/server /usr/src/app
COPY staticAssets.json /usr/src/app
COPY version.json /usr/src/app

EXPOSE 80

CMD node ./index.js
