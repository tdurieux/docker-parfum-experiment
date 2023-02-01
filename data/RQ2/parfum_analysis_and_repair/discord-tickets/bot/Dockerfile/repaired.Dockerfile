FROM node:16

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm i --production && npm cache clean --force;

COPY . .
CMD ["npm", "start"]