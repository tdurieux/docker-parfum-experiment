# Use the official lightweight Node.js image.
# https://hub.docker.com/_/node
FROM node:14

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./
COPY unzip.js ./

# Install production dependencies.
RUN npm install --only=production && npm cache clean --force;

# Copy local code to the container image.
COPY . ./