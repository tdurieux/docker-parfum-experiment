FROM node:7.9.0-alpine
RUN npm install -g nodemon && npm cache clean --force;
WORKDIR /app
ADD package.json .
RUN npm install && npm cache clean --force;
