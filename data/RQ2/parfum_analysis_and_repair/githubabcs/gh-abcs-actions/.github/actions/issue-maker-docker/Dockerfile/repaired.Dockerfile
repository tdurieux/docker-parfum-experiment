FROM node:slim

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "/src/index.js" ]
