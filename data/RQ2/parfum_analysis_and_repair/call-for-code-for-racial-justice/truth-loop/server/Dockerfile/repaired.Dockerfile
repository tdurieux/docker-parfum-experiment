FROM node:14
WORKDIR /usr/src/server
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 5000
CMD ["node", "server.js"]