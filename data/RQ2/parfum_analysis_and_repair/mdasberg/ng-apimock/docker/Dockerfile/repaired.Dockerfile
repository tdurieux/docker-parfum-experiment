FROM node:latest

COPY . /var/www

WORKDIR /var/www

RUN npm install && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT ["npm", "start"]

