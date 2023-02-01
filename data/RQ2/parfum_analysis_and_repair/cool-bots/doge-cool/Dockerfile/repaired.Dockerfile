FROM node:8-alpine

WORKDIR /opt/app
COPY . /opt/app

RUN npm i && npm cache clean --force;
RUN npm i -g forever && npm cache clean --force;

ENTRYPOINT sh /opt/app/app.sh
