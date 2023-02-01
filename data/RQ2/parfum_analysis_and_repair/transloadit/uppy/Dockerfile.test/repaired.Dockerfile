FROM node:16.13.0-alpine

COPY package.json /app/package.json

WORKDIR /app

RUN apk --update --no-cache add --virtual native-dep \
  make gcc g++ python3 libgcc libstdc++ git && \
  corepack yarn install && \
  apk del native-dep
RUN apk add --no-cache bash

COPY . /app
RUN npm install -g nodemon && npm cache clean --force;
CMD ["npm","test"]
