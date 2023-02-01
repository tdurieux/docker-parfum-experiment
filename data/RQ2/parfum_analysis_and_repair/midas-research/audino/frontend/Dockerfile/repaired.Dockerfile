FROM node:14.18.1-alpine

WORKDIR /app/frontend

COPY . /app/frontend

RUN npm install -g npm@8.1.1 && npm cache clean --force;
RUN npm install && npm cache clean --force;

RUN npm run build
