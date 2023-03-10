FROM node:16-alpine AS base

# set working directory
WORKDIR /flow-library

# install git
RUN apk add --no-cache git

# copy project file
COPY ./package.json ./
RUN npm install && npm cache clean --force;
COPY . .
CMD npm run dev
