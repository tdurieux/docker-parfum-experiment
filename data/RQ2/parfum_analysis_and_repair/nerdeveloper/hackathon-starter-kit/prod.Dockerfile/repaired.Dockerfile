FROM node:10-alpine

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

LABEL maintainer="Obinna Odirionye"

COPY ./app ./

COPY variable.env ./

COPY package* ./

RUN npm install --production && npm cache clean --force;

RUN npm i -g nodemon && npm cache clean --force;

CMD ["nodemon", "dist/server.js", "--public"]

