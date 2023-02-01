FROM node:8

WORKDIR /usr/src/app

COPY package*.json .
RUN npm install && npm cache clean --force;
COPY server.js .

EXPOSE 8080
CMD [ "npm", "start" ]
