# Use base node 12-slim image from Docker hub
FROM node:18-slim

WORKDIR /frontend

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Copy rest of the application csource code
COPY . .

# Run app.js
ENTRYPOINT ["node", "app.js"]