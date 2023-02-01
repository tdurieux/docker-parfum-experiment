FROM node:argon

RUN mkdir -p usr/src/app

COPY package.json npm-shrinkwrap.json usr/src/app/
COPY node_shrinkwrap usr/src/app/node_shrinkwrap

WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;

WORKDIR /
COPY . usr/src/app/

WORKDIR /usr/src/app
