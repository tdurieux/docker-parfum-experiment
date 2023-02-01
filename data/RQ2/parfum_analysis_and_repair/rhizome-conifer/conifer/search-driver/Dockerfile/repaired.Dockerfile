FROM node:12.8.0

WORKDIR /app

COPY . /app/
#COPY package.json /app/
#COPY yarn.lock /app/

RUN yarn install && yarn cache clean;

CMD node index.js
