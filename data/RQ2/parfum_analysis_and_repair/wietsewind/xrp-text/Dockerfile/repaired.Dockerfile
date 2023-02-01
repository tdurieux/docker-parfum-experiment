FROM node:carbon
MAINTAINER Wietse Wind <mail@wietse.com>
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;
COPY . .
EXPOSE 4000
CMD [ "node", "index.js" ]