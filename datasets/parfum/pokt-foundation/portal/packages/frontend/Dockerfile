FROM node:16.13

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY package.json $APP_HOME
COPY pnpm-lock.yaml $APP_HOME
COPY .npmrc $APP_HOME

RUN npm i -g pnpm

RUN pnpm i

COPY . $APP_HOME
