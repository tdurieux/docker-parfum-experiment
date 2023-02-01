FROM node:13-alpine

WORKDIR /app

ADD . /app

RUN npm i && npm cache clean --force;

RUN npm run build

CMD npm start