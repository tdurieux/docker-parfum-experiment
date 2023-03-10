FROM node:14-slim

WORKDIR /var/www/ranking_api

COPY . .

RUN npm i && npm cache clean --force;

EXPOSE 4000

CMD node index.js