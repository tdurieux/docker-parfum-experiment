FROM node:12.12.0-alpine

WORKDIR /home/app/api

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 3001

CMD 'npm run prod'
