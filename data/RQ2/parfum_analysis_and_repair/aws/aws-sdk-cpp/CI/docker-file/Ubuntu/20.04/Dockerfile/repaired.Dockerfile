# Using official ubuntu docker image
FROM ubuntu:20.04

# Install git, zip, python-pip, cmake, g++, zlib, libssl, libcurl, java, maven via apt
# Specify DEBIAN_FRONTEND and TZ to prevent tzdata hanging
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles" apt-get --no-install-recommends install -y git zip wget python3 python3-pip cmake g++ zlib1g-dev libssl-dev libcurl4-openssl-dev openjdk-8-jdk doxygen ninja-build && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# Install maven
RUN apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

# Install awscli
RUN pip install --no-cache-dir awscli --upgrade
