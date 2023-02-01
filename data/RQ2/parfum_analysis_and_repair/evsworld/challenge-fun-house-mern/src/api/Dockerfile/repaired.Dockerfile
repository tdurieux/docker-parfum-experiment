FROM node:14-slim

WORKDIR /usr/src/app

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 5000

CMD [ "npm", "start" ]