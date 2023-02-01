FROM node:9.11.1-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV production

COPY package.json yarn.lock /usr/src/app/
RUN yarn install --production && yarn cache clean;

COPY . /usr/src/app

CMD npm start
