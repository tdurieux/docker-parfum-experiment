FROM node:14
RUN mkdir /code
ADD ./package.json /code/package.json
ADD ./yarn.lock /code/yarn.lock
WORKDIR /code
RUN yarn install && yarn cache clean;
RUN yarn add --force node-sass
