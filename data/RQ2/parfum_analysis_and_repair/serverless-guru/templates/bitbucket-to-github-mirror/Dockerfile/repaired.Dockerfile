# base image
FROM lambci/lambda:build-nodejs12.x

WORKDIR /app

RUN npm install serverless -g && npm cache clean --force;

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY index.js /app

COPY tests/ /app

COPY serverless.yml /app