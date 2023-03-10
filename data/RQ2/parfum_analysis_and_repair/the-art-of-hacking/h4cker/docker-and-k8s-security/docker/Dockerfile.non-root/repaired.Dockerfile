# Base Image
FROM node:12-slim
WORKDIR /usr/src/app

# Install Dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Copy in Application
COPY . .

# Set User to Non-Root
USER node

# Run Server
CMD [ "server.js" ]