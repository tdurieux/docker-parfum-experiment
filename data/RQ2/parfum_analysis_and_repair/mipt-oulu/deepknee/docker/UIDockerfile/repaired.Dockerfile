FROM node:10

ARG REACT_APP_BROKER_PORT
ARG REACT_APP_BROKER_ADDR

ENV REACT_APP_BROKER_PORT $REACT_APP_BROKER_PORT
ENV REACT_APP_BROKER_ADDR $REACT_APP_BROKER_ADDR

WORKDIR /usr/src/app
COPY . .

RUN npm install -g serve && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run build

