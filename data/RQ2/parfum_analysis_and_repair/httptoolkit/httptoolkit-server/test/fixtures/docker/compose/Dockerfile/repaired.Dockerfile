FROM node:14

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . .

CMD node /usr/src/app/index.js
