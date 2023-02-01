FROM node:lts

ENV NODE_ENV=production

COPY . /app

WORKDIR /app

RUN yarn install && yarn cache clean;

ENTRYPOINT ["./index.js"]
