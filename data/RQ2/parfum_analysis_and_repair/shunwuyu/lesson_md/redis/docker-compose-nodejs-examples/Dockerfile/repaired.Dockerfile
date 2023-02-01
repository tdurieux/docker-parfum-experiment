FROM node:9.2.1-alpine

RUN mkdir /src

RUN npm install nodemon -g && npm cache clean --force;

WORKDIR /src
ADD app/package.json /src/package.json
RUN npm install && npm cache clean --force;

ADD app/nodemon.json /src/nodemon.json

EXPOSE 3000

CMD npm start