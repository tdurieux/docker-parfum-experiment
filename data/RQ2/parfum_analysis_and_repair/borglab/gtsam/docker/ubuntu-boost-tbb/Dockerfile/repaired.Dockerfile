# Basic Ubuntu 18.04 image with Boost and TBB installed. To be used for building further downstream packages.

# Get the base Ubuntu image from Docker Hub
FROM ubuntu:bionic

# Disable GUI prompts
ENV DEBIAN_FRONTEND noninteractive

# Update apps on the base image
RUN apt-get -y update && apt-get -y install

# Install C++
RUN apt-get -y --no-install-recommends install build-essential apt-utils && rm -rf /var/lib/apt/lists/*;

# Install boost and cmake
RUN apt-get -y --no-install-recommends install libboost-all-dev cmake && rm -rf /var/lib/apt/lists/*;

# Install TBB
RUN apt-get -y --no-install-recommends install libtbb-dev && rm -rf /var/lib/apt/lists/*;
