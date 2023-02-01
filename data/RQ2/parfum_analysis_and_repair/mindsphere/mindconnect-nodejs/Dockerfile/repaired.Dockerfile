# Copyright (C), Siemens AG 2017
# run tests in docker file
FROM node:latest

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "npm", "run", "test" ]

