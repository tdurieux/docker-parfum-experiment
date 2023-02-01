FROM node:dubnium-alpine

MAINTAINER Rodolfo Silva

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .
ADD . .

RUN yarn build

EXPOSE 4000

USER node

CMD ["yarn", "start"]