FROM node:latest

RUN apt-get update
RUN apt-get install -y mc
RUN apt-get install -y nano

RUN mkdir /frontend

ADD package.json /frontend/
ADD . /frontend/

WORKDIR /frontend
RUN npm install
