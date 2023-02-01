FROM node:8
WORKDIR /bitcoin
WORKDIR /opt/01cnode
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
CMD node server.js
EXPOSE 5000
