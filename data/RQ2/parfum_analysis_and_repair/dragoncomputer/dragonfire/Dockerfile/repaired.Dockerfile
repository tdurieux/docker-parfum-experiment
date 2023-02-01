# Use an official Python runtime as a parent image
FROM ubuntu:18.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV PYTHONUNBUFFERED 1 \
    PIP_NO_CACHE_DIR=off

ARG DEBIAN_FRONTEND=noninteractive

# Maintainer
LABEL maintainer="Mehmet Mert Yildiran mert.yildiran@boun.edu.tr"

# Update the apt index
RUN apt-get update
# Install git, make and wget
RUN apt-get install --no-install-recommends -y git make wget && rm -rf /var/lib/apt/lists/*;
# Install OpenSSL and libffi for Tensorflow
RUN apt-get -qqy --no-install-recommends install libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

# Set the working directory to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app

# Install Dragonfire
RUN make dev-install
