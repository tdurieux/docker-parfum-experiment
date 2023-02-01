FROM node:6.11.2

WORKDIR /usr/app

COPY package.json .

RUN npm install --quiet && npm cache clean --force;

COPY . .

EXPOSE 9001
