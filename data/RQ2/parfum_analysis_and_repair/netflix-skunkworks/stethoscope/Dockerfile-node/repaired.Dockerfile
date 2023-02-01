FROM node:7-alpine

ADD stethoscope/ui /code/stethoscope/ui

WORKDIR /code/stethoscope/ui

RUN npm install && npm cache clean --force;