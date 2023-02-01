#
# CloudBoost Services Dockerfile
#

# Pull base image ununtu image.
FROM node:8.2.1

#Maintainer.
MAINTAINER Nawaz Dhandala <nawazdhandala@outlook.com>


RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

# Expose ports.
#   - 3000: CloudBoost HTTP REST API
EXPOSE 3000

#Run the app
CMD [ "npm", "start" ]
