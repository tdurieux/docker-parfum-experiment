FROM node:12-alpine

# Install Chrome for Protractor tests
RUN apk add chromium chromium-chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_DRIVER=/usr/bin/chromedriver

# Create the app directory
WORKDIR /app

# Add the Angular CLI
RUN npm install -g @angular/cli

# Install dependencies
COPY package.json ./
RUN npm install --silent

# Copy application code
COPY . ./
