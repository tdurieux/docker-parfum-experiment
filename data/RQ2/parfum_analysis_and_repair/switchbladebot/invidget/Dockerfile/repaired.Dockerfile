FROM node:lts-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 80

CMD [ "node", "src/index.js" ]