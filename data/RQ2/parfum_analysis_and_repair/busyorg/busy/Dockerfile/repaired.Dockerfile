FROM node:alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN yarn install && yarn cache clean;
RUN yarn build

EXPOSE 3000
CMD yarn start
