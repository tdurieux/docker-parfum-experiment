## SEE: https://github.com/eggjs/egg/issues/1431
FROM node:8.12.0-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/package.json

RUN yarn config set registry 'https://registry.npm.taobao.org' && yarn cache clean;

RUN yarn install && yarn cache clean;

COPY . /usr/src/app

EXPOSE 7000

RUN yarn build

CMD yarn start
