FROM node:carbon-alpine
WORKDIR /www
COPY . /www
RUN npm install && npm cache clean --force;
