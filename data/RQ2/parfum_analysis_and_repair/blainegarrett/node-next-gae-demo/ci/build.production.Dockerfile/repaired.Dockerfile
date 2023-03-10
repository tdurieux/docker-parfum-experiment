# Base the Image off NODE 16
FROM node:16

# Create app directory
WORKDIR /app

# Install Production dependencies
#COPY package*.json ./
COPY . .
RUN npm ci --only=production

# Build
RUN npm run build

# Bundle app source
COPY . .

# The Default Port for the application