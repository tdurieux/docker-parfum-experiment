# Docker file for JuliaBox Engine Base
# Version:1

# Before building image, place:
# - configurations at ./conf
#   - boto configuration at ./conf/.boto
# - sources at ./src

# Engine installed at /jboxengine inside the container
# Configurations are placed at /jboxengine/conf

# Run the image with host mounts:
# - /jboxengine/logs for log files
# - /jboxengine/data for data files like package bundles, user home mounts and backups.
#   - ensure user home mounts are initialized on host
# - /var/run/docker.sock pointing to docker socket

FROM ubuntu:14.04

MAINTAINER Tanmay Mohapatra

RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -y \
    build-essential \
    libreadline-dev \
    libncurses-dev \
    libpcre3-dev \
    libssl-dev \
    netcat \
    git \
    python-setuptools \
    python-dev \
    python-isodate \
    python-pip \
    python-tz \
    libzmq3-dev \
    language-pack-en-base \
    libmysqlclient-dev \
    && apt-get clean

ENV LANG en_US.utf8

RUN pip install tornado \
    futures \
    google-api-python-client \
    PyDrive \
    boto \
    pycrypto \
    psutil \
    sh \
    pyzmq \
    docker-py \
    MySQL-python

# Create docker group and juser which will run the engine.
# Note: Assumption of docker gid=999 may not be true always. But this is better than a 777 permission on the docker socket.
RUN groupadd -g 999 docker \
    && groupadd juser \
    && useradd -m -d /home/juser -s /bin/bash -g juser -G staff,docker juser \
    && echo "export HOME=/home/juser" >> /home/juser/.bashrc \
    && ln -fs /jboxengine/conf/.boto /home/juser/.boto

RUN mkdir /jboxengine /jboxengine/logs \
    && chmod 777 /jboxengine/logs

# Export volume for logs and data
VOLUME /jboxengine/logs
VOLUME /jboxengine/data

# Add static files, configuration, scripts and certificates
ADD conf /jboxengine/conf
ADD src /jboxengine/src
