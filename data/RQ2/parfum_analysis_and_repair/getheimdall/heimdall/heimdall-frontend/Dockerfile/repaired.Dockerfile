FROM node:alpine

WORKDIR /app

COPY package.json .

COPY package-lock.json .

RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

RUN cp -r build /home/build

WORKDIR /home/build

COPY env.js .
COPY .env .

RUN apk add --no-cache bash

RUN npm config set unsafe-perm true
RUN npm install -g serve && npm cache clean --force;

CMD ["/bin/bash", "-c", "node ./env.js ./index.html && serve -s"]