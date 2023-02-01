FROM node:10.16
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
EXPOSE 8080
CMD ["node", "server.js"]