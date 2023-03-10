FROM node

WORKDIR /application

ADD package-lock.json /application/
ADD package.json /application/

RUN npm install && npm cache clean --force;
