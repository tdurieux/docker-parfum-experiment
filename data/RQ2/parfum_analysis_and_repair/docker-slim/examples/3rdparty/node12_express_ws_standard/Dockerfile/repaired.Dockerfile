FROM node:12

WORKDIR /usr/src/app
COPY service/package*.json ./
RUN npm install && npm cache clean --force;
COPY service/ .

EXPOSE 1300
CMD [ "node", "server.js" ]
