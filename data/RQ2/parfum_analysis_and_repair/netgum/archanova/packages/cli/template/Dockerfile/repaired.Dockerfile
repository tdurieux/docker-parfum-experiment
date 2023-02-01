FROM node:latest

WORKDIR /app

COPY package.json .

RUN npm i && npm cache clean --force;

COPY src ./src

CMD [ "npm", "start"]
