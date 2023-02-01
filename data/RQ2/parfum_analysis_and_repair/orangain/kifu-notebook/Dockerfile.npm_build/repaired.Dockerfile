FROM node:10

WORKDIR /app

ADD package.json ./
RUN npm install --quiet && npm cache clean --force;

ADD . ./
