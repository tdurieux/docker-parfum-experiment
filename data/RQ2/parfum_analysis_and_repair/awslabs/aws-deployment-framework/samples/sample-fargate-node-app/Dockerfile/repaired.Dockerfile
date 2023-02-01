FROM node:latest

ADD . .

RUN npm install && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT  ["npm", "start"]
