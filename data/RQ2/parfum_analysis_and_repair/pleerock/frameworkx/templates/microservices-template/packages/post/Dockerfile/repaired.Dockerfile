FROM node:14
WORKDIR /www

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY ./_ .

CMD ["node", "app/start.js" ]