FROM node:carbon-alpine
WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile && yarn cache clean;
CMD yarn start
