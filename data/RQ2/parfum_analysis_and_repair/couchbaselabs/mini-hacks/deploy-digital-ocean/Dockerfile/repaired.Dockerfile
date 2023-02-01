# Set the base image to Ubuntu
FROM ubuntu

# Install Node.js and other dependencies
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    curl -f -sL https://deb.nodesource.com/setup | sudo bash - && \
    apt-get -y --no-install-recommends install python build-essential nodejs && rm -rf /var/lib/apt/lists/*;

# Install nodemon
RUN npm install -g babel && npm cache clean --force;

# Provides cached layer for node_modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN mkdir -p /src && cp -a /tmp/node_modules /src/

# Define working directory
WORKDIR /src
ADD . /src