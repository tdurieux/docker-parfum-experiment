FROM mhart/alpine-node:12 as base

RUN npm i -g lerna && npm cache clean --force;

WORKDIR /app

FROM base as builder

COPY package.json .
COPY yarn.lock .
COPY lerna.json .

COPY packages/client/package.json ./packages/client/package.json

RUN yarn install --pure-lock-file && yarn cache clean;

COPY packages/client ./packages/client

ENV NODE_ENV=production
ENV HOST=http://localhost:5000

RUN yarn build:client && yarn cache clean;

FROM nginx:1.16.0-alpine as server

COPY --from=builder /app/packages/client/build /usr/share/nginx/html

COPY packages/client/nginx.conf /etc/nginx/conf.d/default.conf
