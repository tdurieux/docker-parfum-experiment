FROM node:10.16
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 7777
CMD ["node", "orderserver.js"]