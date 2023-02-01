FROM node:alpine
RUN npm install -g nodemon; npm cache clean --force;
RUN npm install -g webpack webpack-cli@4.9.2 forever; npm cache clean --force;
WORKDIR /usr/src/app