FROM node:10-alpine

WORKDIR /usr/src

COPY . .

RUN npm i && npm cache clean --force;
RUN npm run prepare
RUN npm t

RUN cd docs && npm i && npm run build && mv out /public && npm cache clean --force;

COPY docs/static/* /public/
