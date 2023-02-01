# Dockerfile

# base image
FROM node:alpine

# create & set working directory
RUN mkdir -p /usr/src && rm -rf /usr/src
WORKDIR /usr/src

# copy source files
COPY . /usr/src

# install dependencies
RUN npm i && npm cache clean --force;
RUN cd microservice && npm i && cd .. && npm cache clean --force;
RUN npm install -g concurrently && npm cache clean --force;

# start app
RUN npm run build
EXPOSE 3000
CMD npm run startall
