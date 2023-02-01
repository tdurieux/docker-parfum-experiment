FROM node:12

COPY . /code
WORKDIR /code

RUN npm i && npm cache clean --force;
RUN npm run build:all
