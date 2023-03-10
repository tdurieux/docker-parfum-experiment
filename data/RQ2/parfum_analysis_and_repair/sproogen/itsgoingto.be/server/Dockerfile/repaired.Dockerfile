FROM node:14-alpine
LABEL maintainer="James Grant <james@jwgmedia.co.uk> (http://jameswgrant.co.uk)"

WORKDIR /server
COPY package*.json ./
RUN npm i && npm cache clean --force;
