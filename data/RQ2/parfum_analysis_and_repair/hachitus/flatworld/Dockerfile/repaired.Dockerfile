FROM node:9.11.1

WORKDIR /var/www/flatworld

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 8080

CMD [ "npm", "start:dev" ]