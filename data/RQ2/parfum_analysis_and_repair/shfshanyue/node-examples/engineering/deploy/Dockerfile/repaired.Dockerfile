FROM node:16-alpine

WORKDIR /code
ADD . /code

RUN npm install && npm cache clean --force;
CMD npm start

EXPOSE 8080