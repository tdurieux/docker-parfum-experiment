FROM node:latest

WORKDIR /usr/src/app

ADD ./ ./

RUN npm i && npm cache clean --force;

EXPOSE 3000

CMD [ "npm", "start" ]