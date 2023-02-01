FROM node:14

WORKDIR /usr/src/forestswar

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "index.js" ]
