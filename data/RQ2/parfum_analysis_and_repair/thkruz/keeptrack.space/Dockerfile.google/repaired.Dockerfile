# Load NodeJs and call it "builder"
FROM node:16 as builder

# Copy the app files over to the container
WORKDIR /app

COPY package.json package-lock.json tsconfig.json ./
COPY src src
COPY scripts scripts
# COPY node_modules node_modules

# Install Packages
RUN npm ci --ignore-scripts
RUN npm run build

# Load nginx image
FROM nginx

# Copy the build files from builder's /app/dist to the nginx container