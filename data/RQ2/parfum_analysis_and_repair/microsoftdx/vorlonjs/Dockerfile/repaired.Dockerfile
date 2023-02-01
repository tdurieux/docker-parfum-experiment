# use the node argon (4.4.3) image as base
FROM node:argon

# Set the Vorlon.JS Docker Image maintainer
MAINTAINER Julien Corioland (Microsoft, DX)

# Expose port 1337
EXPOSE 1337

# Upgrade to last NPM version
RUN npm upgrade -g npm

# Install gulp
RUN npm install -g gulp && npm cache clean --force;

# Set the entry point
ENTRYPOINT ["npm", "start"]

# Create the application directory
RUN mkdir -p /usr/src/vorlonjs && rm -rf /usr/src/vorlonjs

# Copy the application content
COPY . /usr/src/vorlonjs/

# Set app root as working directory
WORKDIR /usr/src/vorlonjs

# Run npm install
RUN npm install && npm cache clean --force;

# Run gulp
RUN gulp
