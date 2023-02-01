FROM node:current-buster

ADD /frontend /frontend
WORKDIR /frontend

RUN npm install --legacy-peer-deps && npm cache clean --force;

EXPOSE 3000
