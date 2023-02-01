#Use dockerhub image for Node
FROM node:10

#Install Webpack globally
RUN npm install -g webpack && npm cache clean --force;

#Create App Directory
WORKDIR /usr/src/app

ENV NODE_ENV=development


#INSTALL APP DEPENDENCIES
COPY package*.json /usr/src/app/
RUN npm install compression-webpack-plugin && npm cache clean --force;
RUN npm install && npm cache clean --force;

#EXPOSE PORTS
EXPOSE 3000