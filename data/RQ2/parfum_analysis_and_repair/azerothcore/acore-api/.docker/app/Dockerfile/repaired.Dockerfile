FROM node:12.13-alpine As development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm i -g @nestjs/cli && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build