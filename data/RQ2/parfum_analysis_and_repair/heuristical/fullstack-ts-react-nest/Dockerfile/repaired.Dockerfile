FROM node:10-alpine

ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --production && npm cache clean --force;

COPY ./dist ./dist
COPY ./index.js .

CMD [ "npm", "run", "prod" ]