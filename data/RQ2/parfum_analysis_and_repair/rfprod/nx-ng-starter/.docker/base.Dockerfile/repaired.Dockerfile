# Base NodeJS image for apps.

# Define image.
FROM node:16.15.1-alpine
# Set environment variables.
ENV DEBIAN_FRONTEND=noninteractive
# Create app directory.
WORKDIR /app
# Copy dist.
COPY /package.json .
COPY /yarn.lock .
# Install dependencies.