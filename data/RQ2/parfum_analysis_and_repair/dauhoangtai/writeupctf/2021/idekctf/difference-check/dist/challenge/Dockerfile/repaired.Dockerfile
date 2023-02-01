FROM node:alpine

RUN mkdir /app

WORKDIR /app

ADD . /app

RUN npm install && npm cache clean --force;

EXPOSE 1337

ENTRYPOINT ["node", "index.js"]
