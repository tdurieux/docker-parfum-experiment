FROM node:16

RUN npm i -g serverless@3 && npm cache clean --force;
