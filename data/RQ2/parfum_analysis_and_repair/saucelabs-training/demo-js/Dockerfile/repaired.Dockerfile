FROM node:10
WORKDIR /demo-js
COPY . /demo-js
RUN npm install && npm cache clean --force;
EXPOSE 8081