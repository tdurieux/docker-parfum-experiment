FROM node:14.17
WORKDIR /usr/src/notion-page-to-html
RUN npm -g i npm && npm cache clean --force;
COPY ./package*.json ./
RUN npm install && npm cache clean --force;
COPY . .