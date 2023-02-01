FROM node:14

RUN mkdir /app
WORKDIR /app
COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean;

COPY . .
RUN yarn build
