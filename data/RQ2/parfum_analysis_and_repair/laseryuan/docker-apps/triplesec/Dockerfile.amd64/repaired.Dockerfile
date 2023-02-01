FROM node:11.15.0-stretch



ENV LANG C.UTF-8

RUN npm install triplesec && npm cache clean --force;
RUN npm install readline-sync && npm cache clean --force;



USER node
WORKDIR /home/node
