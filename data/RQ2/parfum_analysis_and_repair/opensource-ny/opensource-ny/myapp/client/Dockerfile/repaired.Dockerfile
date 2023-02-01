FROM node:13.0.1-alpine
WORKDIR /client

COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .

CMD npm start