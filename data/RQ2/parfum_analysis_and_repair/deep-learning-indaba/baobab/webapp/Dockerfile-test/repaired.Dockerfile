FROM node:13 as build-deps
WORKDIR /webapp
COPY package.json yarn.lock ./
RUN yarn
COPY . ./