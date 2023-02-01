# debian 9
FROM node:12

RUN mkdir /app

RUN npm install -g nodemon && npm cache clean --force;

RUN npm i -g pm2 && \
  pm2 install pm2-logrotate && npm cache clean --force;

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE 3000
