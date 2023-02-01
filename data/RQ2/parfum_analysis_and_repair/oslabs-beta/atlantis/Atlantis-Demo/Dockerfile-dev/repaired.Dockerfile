FROM node:16.3
RUN npm install -g webpack && npm cache clean --force;
WORKDIR '/usr/src/app'
COPY package*.json ./
RUN npm install && npm cache clean --force;
EXPOSE 3000
