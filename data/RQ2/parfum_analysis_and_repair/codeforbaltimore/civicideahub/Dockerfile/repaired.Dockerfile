FROM node:7

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm i && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 3000

CMD npm start
