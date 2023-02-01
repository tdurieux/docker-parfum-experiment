FROM node:10-alpine

WORKDIR /usr/src

COPY package.json .
COPY package-lock.json .

RUN npm i && npm cache clean --force;

COPY . .

RUN cd docs && npm i && npm run build && npm cache clean --force;

RUN mv docs/dist /public
