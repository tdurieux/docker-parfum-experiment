# Use a node 16 base image
ARG NODE_VERSION=16
FROM node:${NODE_VERSION}-alpine

WORKDIR /usr/src/app

# Copy package.json and install node modules
COPY package*.json ./
RUN npm ci

# Add app source code
ADD . /usr/src/app

# Build app
RUN npm run tsc

# Install berglas