FROM node:13.12.0-alpine as build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package*.json ./
RUN npm install -g && npm cache clean --force;
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent && npm cache clean --force;

RUN npm install --slient && npm cache clean --force;

COPY . ./

CMD npm run build