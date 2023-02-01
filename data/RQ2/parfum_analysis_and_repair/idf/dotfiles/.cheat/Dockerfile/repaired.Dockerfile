// Dockerfile encapsulate the shared common dependencies for containers
# Image
FROM ubuntu:14.04
## Or
FROM node:7.0.0

# RUN executes command(s) in a new layer and creates a new image. E.g., it is often used for installing software packages.
RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    python \
    redis-server && rm -rf /var/lib/apt/lists/*;

# Create directory
RUN mkdir -p /root/app
WORKDIR /root/app

# Install app dependencies
COPY file /path/to/folder
COPY folder /path/to/folder

# Add: Local-only tar extraction and remote URL support
ADD URL /path/to/folder

RUN npm install && npm cache clean --force;

# Expose localhost port
EXPOSE 80

# CMD sets default command and/or parameters, which can be overwritten from command line when docker container runs.
# Normally to start some services/applications on the container without affecting the images
CMD ["/bin/bash", "start_service.sh"]
