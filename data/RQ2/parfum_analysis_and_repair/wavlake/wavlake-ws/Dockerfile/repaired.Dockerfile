FROM node:16.13.0

WORKDIR /usr/src/app

COPY package*.json ./
COPY controller/ controller
COPY db/ db
COPY library/ library
COPY routes/ routes
COPY index.js index.js

RUN npm install && npm cache clean --force;

EXPOSE 3002
CMD ["npm", "start"]