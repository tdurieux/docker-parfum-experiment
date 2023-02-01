# Docker version 1.9.1, build a34a1d5
# Build image using the latest version of Ubuntu from the Docker Hub Ubuntu repository.
FROM ubuntu:16.04

# Declare the MAINTAINER of the Dockerfile
MAINTAINER Ashwin Hegde <ashwin.hegde3@gmail.com>

# Make sure apt is up to date
RUN apt-get update && apt-get install --no-install-recommends -y nodejs nodejs-legacy npm git && rm -rf /var/lib/apt/lists/*; # Install nodejs and npm


# Create app directory
RUN mkdir -p /usr/nebula
WORKDIR /usr/nebula

# Install dependencies at global level
RUN npm install -g grunt-cli && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;

# Install app dependencies
COPY package.json /usr/nebula
COPY bower.json /usr/nebula
RUN npm install && npm cache clean --force;
RUN bower install --allow-root

# Bundle app source
COPY . /usr/nebula

# Run source build
RUN grunt build

# Your app binds to port 8000 so you'll use the EXPOSE instruction
# to have it mapped by the docker daemon
EXPOSE 8000

# Execute command and start Node.js server
CMD [ "npm", "run", "docker" ]
