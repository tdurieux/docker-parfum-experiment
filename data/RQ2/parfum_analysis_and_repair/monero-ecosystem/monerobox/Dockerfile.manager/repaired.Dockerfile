# specify the base image
FROM moneroboxdev/docker-compose:1.24.0

# Create app directory
WORKDIR /usr/src/app

# clone the repo