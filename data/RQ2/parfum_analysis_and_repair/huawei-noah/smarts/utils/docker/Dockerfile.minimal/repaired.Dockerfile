# Steps to build and push minimal SMARTS docker image
# ```bash
# $ cd </path/to/SMARTS>
# export VERSION=v0.5.0
# $ docker build --no-cache -f ./utils/docker/Dockerfile.minimal -t huaweinoah/smarts:$VERSION-minimal .
# $ docker login
# $ docker push huaweinoah/smarts:$VERSION-minimal
# ```

FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

# Install libraries
RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y \
        software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:sumo/stable && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        libspatialindex-dev \
        python3.7 \
        python3.7-venv \
        sumo \
        sumo-doc \
        sumo-tools \
        wget \
        xorg && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Setup SUMO
ENV SUMO_HOME /usr/share/sumo

# Update default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Setup pip
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python get-pip.py && \
    pip install --no-cache-dir --upgrade pip

# For Envision
EXPOSE 8081

# Suppress message of missing /dev/input folder
RUN echo "mkdir -p /dev/input" >> ~/.bashrc

SHELL ["/bin/bash", "-c", "-l"]
