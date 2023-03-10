# pull official base image
FROM node:14.18.1-alpine AS builder

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# copy npm dependencies
COPY package.json package-lock.json /app/

# install dependencies
RUN apk add --no-cache git
RUN git config --global url."https://".insteadOf ssh:// && npm ci --only=production

# copy rest of app
COPY . .

# start app in production mode