FROM node:12-alpine

# Create the app directory
WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install --silent && npm cache clean --force;

# Copy application code
COPY . ./
