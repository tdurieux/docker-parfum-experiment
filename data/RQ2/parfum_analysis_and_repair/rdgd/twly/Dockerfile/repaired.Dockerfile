FROM node:alpine

WORKDIR /twly

COPY . /twly

RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "/twly/index.js"]

