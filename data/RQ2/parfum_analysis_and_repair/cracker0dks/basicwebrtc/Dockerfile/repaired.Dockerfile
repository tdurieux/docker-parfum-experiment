FROM node:14-slim

MAINTAINER cracker0dks

# Create app directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install app dependencies
COPY ./package.json /opt/app
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /opt/app

EXPOSE 3001
CMD [ "npm", "start" ]