FROM node:current-alpine

RUN apk add --no-cache python3 make g++

COPY . /app
WORKDIR /app

RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

ENTRYPOINT ["node", "/app/build/index.js"]
