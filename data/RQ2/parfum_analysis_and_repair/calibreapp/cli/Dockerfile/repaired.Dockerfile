FROM node:alpine
RUN apk add --no-cache zip bash

# Copy to /cli
RUN mkdir /cli
WORKDIR /cli
COPY package.json package-lock.json /cli/
RUN npm install && npm cache clean --force;

COPY . /cli
