FROM node:12

WORKDIR /usr/src/app

COPY package* /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app/
CMD npm start
