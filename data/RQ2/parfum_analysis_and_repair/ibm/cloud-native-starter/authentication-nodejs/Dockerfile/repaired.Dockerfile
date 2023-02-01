FROM node:8-alpine

WORKDIR /usr/src/app
COPY package.json ./
COPY server.js ./
COPY .env ./

RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["npm", "start"]