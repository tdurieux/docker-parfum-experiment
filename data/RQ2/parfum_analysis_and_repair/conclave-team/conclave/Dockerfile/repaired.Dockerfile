FROM node:14

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3000

