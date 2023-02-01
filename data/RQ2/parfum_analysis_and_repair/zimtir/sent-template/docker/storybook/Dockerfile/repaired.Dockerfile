FROM node:lts-alpine

WORKDIR /var/www/web/storybook

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 6006
