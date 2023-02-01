FROM node:10.13.0-alpine

WORKDIR /app/

COPY package.json ./

COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . ./

CMD ["node", "/app/index.js"]
