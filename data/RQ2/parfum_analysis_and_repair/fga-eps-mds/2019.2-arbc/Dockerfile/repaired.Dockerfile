FROM node:carbon-alpine

ENV ArBC_FRONTEND=noninteractive

WORKDIR /usr/app

RUN npm install -g @vue/cli && npm cache clean --force;

COPY package*.json ./

RUN npm install && npm cache clean --force;

RUN ["chmod", "777", "node_modules"]

COPY . .

EXPOSE 8080
CMD ["npm", "run","serve"]