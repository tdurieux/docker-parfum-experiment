FROM node:8

WORKDIR /usr/src/app

COPY package* /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app/
CMD npm run serve -- --host 0.0.0.0
