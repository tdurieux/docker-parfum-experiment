FROM node:11

WORKDIR /reverb/rest

COPY package.json .
RUN npm install && npm cache clean --force;

COPY server.js .

EXPOSE $PORT