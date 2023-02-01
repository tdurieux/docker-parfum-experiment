FROM node:latest

RUN mkdir /src

RUN npm install nodemon -g && npm cache clean --force;

WORKDIR /src
ADD . /src
RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD npm start