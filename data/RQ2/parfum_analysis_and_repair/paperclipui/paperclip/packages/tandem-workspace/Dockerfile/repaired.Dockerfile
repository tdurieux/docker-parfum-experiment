FROM node:14

WORKDIR /usr/src/app

COPY . .

RUN yarn install && yarn cache clean;
RUN yarn build

EXPOSE 3003