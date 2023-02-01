FROM node:8

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .
RUN rm data/data.json

EXPOSE 3000
CMD [ "node", "app.js" ]