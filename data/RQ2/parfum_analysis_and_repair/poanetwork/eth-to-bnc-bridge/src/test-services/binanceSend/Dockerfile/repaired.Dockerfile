FROM node:10.16.0-alpine

WORKDIR /test

RUN apk add --no-cache build-base python

COPY package.json /test/

RUN npm install && npm cache clean --force;

COPY testBinanceSend.js /test/

ENTRYPOINT ["node", "testBinanceSend.js"]
