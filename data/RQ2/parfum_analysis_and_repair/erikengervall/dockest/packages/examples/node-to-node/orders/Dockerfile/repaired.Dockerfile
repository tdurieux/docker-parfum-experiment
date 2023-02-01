# https://nodejs.org/de/docs/guides/nodejs-docker-webapp/
FROM node:10-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "./index" ]
