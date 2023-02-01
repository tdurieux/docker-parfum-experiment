FROM node:15-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . ./

CMD ["npm", "run", "processLogs"]
