FROM node:latest

RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /app

COPY . .

RUN yarn install && yarn cache clean;
