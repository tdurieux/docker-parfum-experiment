# Base Image
FROM node:12-slim
WORKDIR /usr/src/app

# Install Dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Copy in Application
COPY . .

# Run Server
CMD [ "server.js" ]