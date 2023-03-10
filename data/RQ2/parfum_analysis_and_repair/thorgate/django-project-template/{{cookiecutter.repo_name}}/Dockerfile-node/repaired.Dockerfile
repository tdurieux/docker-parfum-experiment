# Based on Node {{ cookiecutter.node_version }} Alpine image
FROM node:{{ cookiecutter.node_version }}-alpine

# Install system requirements
RUN apk add --no-cache alpine-sdk python3 bash

# Set the default directory where CMD will execute
WORKDIR /app

# Set the default command to execute when creating a new container