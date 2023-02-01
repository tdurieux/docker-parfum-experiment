FROM node:14

WORKDIR /src

RUN npm install -g codecov && npm cache clean --force;

COPY package.json /src
COPY package-lock.json /src
RUN npm install && npm cache clean --force;

COPY . /src
