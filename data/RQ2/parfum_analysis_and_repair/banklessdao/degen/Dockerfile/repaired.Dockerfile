FROM node:16.10.0-alpine

WORKDIR /app

COPY package*.json ./

RUN yarn install && yarn cache clean;

COPY . ./

RUN yarn build

CMD ["yarn", "start"]