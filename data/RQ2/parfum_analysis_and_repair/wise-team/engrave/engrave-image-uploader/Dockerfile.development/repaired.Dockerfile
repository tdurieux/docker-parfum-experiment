FROM node:alpine

RUN npm install -g typescript nodemon && npm cache clean --force;

WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install && npm cache clean --force;

COPY src src

RUN npm run build

CMD npm run watch