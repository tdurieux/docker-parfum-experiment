FROM node:8.12.0-alpine

WORKDIR /src
EXPOSE 3000
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

CMD [ "node", "server.js" ]