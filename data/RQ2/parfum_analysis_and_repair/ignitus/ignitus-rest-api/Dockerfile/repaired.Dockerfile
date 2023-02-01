FROM node:10

WORKDIR /usr/src/api

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 4000

CMD [ "npm", "start" ]
