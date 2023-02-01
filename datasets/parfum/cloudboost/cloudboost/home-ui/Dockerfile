#
# CloudBoost Home Dockerfile
#

# Pull base image nodejs image.
FROM node:8.9.0

#Maintainer.
MAINTAINER Nawaz Dhandala <nawazdhandala@outlook.com>

#SET ENV Variables. 

ENV PRODUCTION=true


RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

# Expose ports.
#   - 1444: CloudBoost Home
EXPOSE 1444

#Run the app
CMD [ "npm", "start" ]
