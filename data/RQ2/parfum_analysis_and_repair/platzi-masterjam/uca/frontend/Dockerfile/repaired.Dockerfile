# Dockerfile

# base image
FROM node:alpine

# create & set working directory
RUN mkdir -p /usr/src && rm -rf /usr/src
WORKDIR /usr/src

# copy source files
COPY . /usr/src

# install dependencies
RUN npm install && npm cache clean --force;

# start app
RUN npm run build
EXPOSE 8000
CMD npm run dev
