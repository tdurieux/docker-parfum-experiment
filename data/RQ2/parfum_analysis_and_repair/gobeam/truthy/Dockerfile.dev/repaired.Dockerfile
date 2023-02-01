FROM node:14-alpine As development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=development && npm cache clean --force;

COPY . .

RUN npm run start:dev