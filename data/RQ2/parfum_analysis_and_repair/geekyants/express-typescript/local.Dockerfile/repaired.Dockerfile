FROM node:10.5.0

WORKDIR /usr/src/app

RUN npm install -g nodemon && npm cache clean --force;

RUN npm install -g typescript && npm cache clean --force;

EXPOSE 4040 5550