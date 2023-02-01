FROM node:10 as build

WORKDIR /app/bot

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . ./
RUN npm run build

CMD npm start
