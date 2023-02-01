FROM node:fermium-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]
