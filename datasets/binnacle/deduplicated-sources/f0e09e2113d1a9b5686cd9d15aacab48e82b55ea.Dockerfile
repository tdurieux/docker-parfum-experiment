#################################
# Development
#################################
FROM node:10.1-alpine as build

# Create app folder
RUN mkdir /app
WORKDIR /app

# Copy package*.json to app folder
COPY package.json package-lock.json /app/

# Install app dependencies
RUN npm install -g @angular/cli
RUN npm set progress=false
RUN npm install

# Copy all files to app folder
COPY . /app

# Add configuration files
COPY image-files/ /
RUN chmod 700 /usr/local/bin/docker-entrypoint-dev.sh

# Install nginx
RUN apk --update add nginx

# Expose port 80
EXPOSE 80
ENTRYPOINT ["docker-entrypoint-dev.sh"]
