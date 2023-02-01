FROM node:17.4.0-buster-slim

RUN mkdir -p /app

WORKDIR /app

COPY package.json .

RUN yarn && yarn cache clean;

COPY . .

USER node

CMD ["node", "index.js"]

