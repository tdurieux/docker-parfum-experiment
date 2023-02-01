FROM node:16-alpine

RUN npm install -g apib2swagger && npm cache clean --force;

ENTRYPOINT ["apib2swagger"]