FROM node:14.17
RUN npm install webpack -g && npm cache clean --force;
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
EXPOSE 8080