FROM node:10.20-jessie

COPY . /challenge-api

RUN ( cd /challenge-api && npm install) && npm cache clean --force;

WORKDIR /challenge-api/mock-api

RUN npm install && npm cache clean --force;

CMD npm start
