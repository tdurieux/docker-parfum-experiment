FROM node:12

RUN mkdir /code
WORKDIR /code

COPY package.json package-lock.json webpack.config.js /code/
RUN npm install && npm cache clean --force;
