############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
# Following https://www.digitalocean.com/community/tutorials/docker-explained-how-to-containerize-and-use-nginx-as-a-proxy
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Martin Grotzke

# Install Nginx

# Add application repository URL to the default sources
RUN echo "deb http://de.archive.ubuntu.com/ubuntu/ trusty main universe" >> /etc/apt/sources.list

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install --no-install-recommends -y vim wget dialog net-tools && rm -rf /var/lib/apt/lists/*;

# Download and Install Nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Copy a configuration file from the current directory
COPY nginx.conf /etc/nginx/

# Expose ports
EXPOSE 80

# Set the default command to execute
# when creating a new container
CMD service nginx start