FROM node:14.17.6
RUN npm i -g webpack && npm cache clean --force;
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm i && npm cache clean --force;
EXPOSE 8080
