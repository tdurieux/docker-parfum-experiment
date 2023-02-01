# Node image to use
FROM node:16-alpine

# Directory where we run all the commands
WORKDIR /usr/local/apps/inventory-app

# Set working directory to /dev
WORKDIR /usr/local/apps/inventory-app/dev

# Copy all project files including node_modules because my internet can't handle
# installing them on every build