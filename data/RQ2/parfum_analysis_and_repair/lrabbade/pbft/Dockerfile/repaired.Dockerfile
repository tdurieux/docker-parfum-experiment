FROM node:10

COPY . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE 3000
