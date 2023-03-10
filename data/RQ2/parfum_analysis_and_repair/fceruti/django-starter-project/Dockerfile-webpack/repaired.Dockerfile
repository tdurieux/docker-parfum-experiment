# Pull base image
FROM node:latest

# Set work directory
WORKDIR /code

# Copy webpack config
COPY assets/webpack.config.js ./

# Install node modules
COPY assets/package*.json ./
RUN npm install && npm cache clean --force;
RUN npm rebuild node-sass  # Fix issue: https://github.com/sass/node-sass/issues/2536
