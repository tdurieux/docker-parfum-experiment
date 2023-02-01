FROM node:latest

RUN mkdir -p /usr/src/app/react-src && rm -rf /usr/src/app/react-src
WORKDIR /usr/src/app

RUN npm install -g nodemon && npm cache clean --force;

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY react-src/package.json /usr/src/app/react-src
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 3000 4200
