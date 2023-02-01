FROM node:10.16.0-alpine

WORKDIR /test

COPY package.json /test/

RUN npm install && npm cache clean --force;

COPY testGetAddresses.js /test/

ENTRYPOINT ["node", "testGetAddresses.js"]
