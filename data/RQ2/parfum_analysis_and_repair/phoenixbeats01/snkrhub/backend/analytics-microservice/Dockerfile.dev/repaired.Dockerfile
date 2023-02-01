# Node image to use
FROM node:16-alpine

# Set working directory to /dev
WORKDIR /usr/local/apps/analytics-app/dev

# Copy all project files including node_modules because my internet can't handle
# installing them on every build