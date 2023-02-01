FROM node

MAINTAINER Andrey Lobarev <nxtpool@gmail.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
COPY . /usr/src/app

CMD [ "npm", "start" ]

EXPOSE 3000

