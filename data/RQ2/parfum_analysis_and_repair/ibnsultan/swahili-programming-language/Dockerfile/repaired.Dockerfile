FROM node:8.9.4

WORKDIR /src

COPY . /src

RUN npm install && npm cache clean --force;

RUN npm run link
