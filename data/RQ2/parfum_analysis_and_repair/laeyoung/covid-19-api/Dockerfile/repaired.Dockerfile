FROM node:12-alpine
WORKDIR /workspace
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 80

CMD [ "node", "server.js" ]