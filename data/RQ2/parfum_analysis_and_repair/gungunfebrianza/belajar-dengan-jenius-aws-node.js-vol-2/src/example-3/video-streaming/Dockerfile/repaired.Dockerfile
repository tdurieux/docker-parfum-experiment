FROM node:12.18.1-alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;
COPY ./src ./src
COPY ./videos ./videos
CMD npm start