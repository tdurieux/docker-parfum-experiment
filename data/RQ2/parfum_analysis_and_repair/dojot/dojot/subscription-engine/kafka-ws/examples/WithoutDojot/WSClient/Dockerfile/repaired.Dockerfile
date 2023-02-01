FROM node:10.16.3-alpine

WORKDIR /opt/ws-client

COPY package.json .
COPY package-lock.json .

RUN npm install && npm cache clean --force;

COPY Client.js .

CMD ["node", "Client.js"]
