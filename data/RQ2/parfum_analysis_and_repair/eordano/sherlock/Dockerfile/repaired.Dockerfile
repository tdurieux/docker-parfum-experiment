FROM ubuntu:latest

MAINTAINER Esteban Ordano <eordano@gmail.com>

# Download and install nodejs and npm
RUN apt-get update && apt-get install --no-install-recommends -y npm curl git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade

RUN npm install -g n && npm cache clean --force;
RUN n latest

# Shared volume
RUN mkdir -p /var/sherlock
COPY "./package.json" "/var/sherlock/"
WORKDIR "/var/sherlock"

# Install deps
RUN npm install && npm cache clean --force;

# Default command for container, start server
CMD ["npm", "start"]

# Expose port 3000 of the container
EXPOSE 3000
