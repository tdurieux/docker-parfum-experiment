# Using the base image with nvidia
FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

# Non-interactive Debian front-end
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Updating apt and installing the dependencies
RUN apt-get -y update &&\
    apt-get --no-install-recommends install -y libgraphviz-dev &&\
    apt-get --no-install-recommends install -y rapidjson-dev &&\
    apt-get --no-install-recommends install -y libtbb-dev &&\
    apt-get --no-install-recommends install -y git &&\
    apt-get --no-install-recommends install -y doxygen &&\
    apt-get --no-install-recommends install -y hwloc &&\
    apt-get --no-install-recommends install -y wget &&\
    apt-get --no-install-recommends install -y librdkafka-dev &&\
    rm -rf /var/lib/apt/lists/*

# Using a sufficiently recent version of cmake
ARG CMAKE_VERSION=3.22.1

# Downloading and installing cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh -q -O /tmp/cmake-install.sh &&\
    chmod u+x /tmp/cmake-install.sh &&\
    mkdir /usr/bin/cmake &&\
    /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake &&\
    rm /tmp/cmake-install.sh

# Configuring the PATH
ENV PATH="/usr/bin/cmake/bin:${PATH}"

# Creating the guest user
RUN useradd -ms /bin/bash guest

# Using guest and its home folder
USER guest
WORKDIR /home/guest

# Downloading the FastFlow and WindFlow libraries, and configuring them