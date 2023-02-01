# base image
FROM node:13.12.0-alpine3.11

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# g++ compiler for fibers and sass
RUN apk add --no-cache python make g++

# install app dependencies
COPY ./ui/package.json /app/package.json
COPY ./ui/package-lock.json /app/package-lock.json
RUN npm install && npm cache clean --force;
RUN npm install @vue/cli -g && npm cache clean --force;

# copy files
COPY ./ui /app

CMD npm run serve
