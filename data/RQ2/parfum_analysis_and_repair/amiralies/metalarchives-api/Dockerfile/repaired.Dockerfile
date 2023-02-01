FROM node:carbon-alpine

WORKDIR /var/www/metalarchives-api
COPY package*.json ./
RUN npm install -g pm2 && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY . .
CMD ./start.sh
EXPOSE 3000
