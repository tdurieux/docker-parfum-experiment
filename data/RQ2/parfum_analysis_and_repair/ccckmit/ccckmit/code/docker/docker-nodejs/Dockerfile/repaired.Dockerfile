FROM node:carbon
MAINTAINER ccckmit <ccckmit@gmail.com>

WORKDIR /root/docker/docker-nodejs2
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 3001
CMD ["npm", "start"]

