FROM node:alpine

COPY . /app
WORKDIR /app

RUN npm install && npm cache clean --force;

CMD npm start

