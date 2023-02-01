FROM node:alpine

WORKDIR ~/app

COPY package*.json ./

RUN npm i --silent && npm cache clean --force;

COPY . .


CMD ["npm", "run", "dev"]