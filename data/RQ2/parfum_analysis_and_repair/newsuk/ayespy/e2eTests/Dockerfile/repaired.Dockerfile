FROM node:9.11.2-alpine

WORKDIR /home/node/app

COPY . .

RUN yarn && yarn cache clean;

CMD yarn test:e2e
