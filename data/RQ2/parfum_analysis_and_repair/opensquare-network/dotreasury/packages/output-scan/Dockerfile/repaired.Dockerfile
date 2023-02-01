# Dockerfile

# base image
FROM node:alpine

# create & set working directory
RUN mkdir -p /usr/src && rm -rf /usr/src
WORKDIR /usr/src

# copy source files
COPY . /usr/src

# install dependencies
RUN yarn install && yarn cache clean;
CMD yarn run scan
