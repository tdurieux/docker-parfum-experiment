FROM node:boron

RUN npm install protractor -g && npm cache clean --force;
RUN npm install webpack -g && npm cache clean --force;
RUN npm install webpack-dev-server -g && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

CMD npm start
