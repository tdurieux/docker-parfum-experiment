FROM node:{{nodeJsVersion}}-alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;
COPY ./src ./src

CMD npm start