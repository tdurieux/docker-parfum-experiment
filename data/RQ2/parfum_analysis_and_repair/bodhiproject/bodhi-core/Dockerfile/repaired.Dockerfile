# set the base image to Node
# which is built off Debian Jessie
FROM node:8.6

# create directory and add module list
WORKDIR /bodhi-core
ADD package.json package.json

# install node modules
RUN npm install -g truffle@^4.0.0-beta.2 && npm cache clean --force;
RUN npm install && npm cache clean --force;

ADD . .
