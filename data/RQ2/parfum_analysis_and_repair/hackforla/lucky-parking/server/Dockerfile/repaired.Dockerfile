FROM node:16-alpine AS dev

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "server:dev"]