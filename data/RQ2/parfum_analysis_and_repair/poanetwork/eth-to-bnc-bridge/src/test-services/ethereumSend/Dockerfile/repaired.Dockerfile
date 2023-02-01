FROM node:10.16.0-alpine

WORKDIR /test

COPY package.json /test/

RUN npm install && npm cache clean --force;

COPY testEthereumSend.js /test/

ENTRYPOINT ["node", "testEthereumSend.js"]
