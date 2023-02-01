FROM node:latest

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src

COPY package.json /usr/src/

RUN yarn install && yarn cache clean;

COPY . /usr/src/app

WORKDIR /usr/src/app

EXPOSE 3000

CMD ["yarn", "start"]