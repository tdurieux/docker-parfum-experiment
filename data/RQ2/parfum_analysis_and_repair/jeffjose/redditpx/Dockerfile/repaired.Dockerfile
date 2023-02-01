# # Use the official lightweight Node.js 12 image.
# https://hub.docker.com/_/node
FROM docker.io/node:17-slim

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./
COPY yarn.lock ./

# Install dev + production dependencies.
RUN yarn

# Copy local code to the container image.
COPY . ./

# Build sapper
RUN yarn build

# Run the web service on container startup.