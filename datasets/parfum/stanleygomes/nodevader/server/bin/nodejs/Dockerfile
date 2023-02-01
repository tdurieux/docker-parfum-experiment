# debian 9
FROM node:12

RUN mkdir /app

RUN npm install -g nodemon

RUN npm i -g pm2 && \
  pm2 install pm2-logrotate

WORKDIR /app

RUN npm install

EXPOSE 3000
