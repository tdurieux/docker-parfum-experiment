FROM node:16

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install packages
RUN npm install && npm cache clean --force;

# Copy the app code
COPY . .

# Build the project
RUN npm run build

# Expose ports
EXPOSE 8080

# Run the application
CMD [ "node", "dist/start-manager.js" ]
