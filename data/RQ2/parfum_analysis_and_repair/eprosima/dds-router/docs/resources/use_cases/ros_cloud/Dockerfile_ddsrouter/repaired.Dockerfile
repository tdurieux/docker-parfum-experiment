FROM ubuntu:focal

WORKDIR /ddsrouter

# Needed for a dependency that force to set timezone
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Get ubuntu repositories information and install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        git \
        build-essential \
        cmake \
        libssl-dev \
        libasio-dev \
        libtinyxml2-dev \
        libyaml-cpp-dev \
        wget \
        python3-pip && \
    pip3 install --no-cache-dir colcon-common-extensions vcstool && rm -rf /var/lib/apt/lists/*;

# Download and build DDS-Router
RUN mkdir resources && \
    wget https://raw.githubusercontent.com/eProsima/DDS-Router/main/ddsrouter.repos && \
    mkdir src && \
    vcs import src < ddsrouter.repos && \
    colcon build --event-handlers=console_direct+

SHELL ["/bin/bash", "-c"]
CMD source ./install/setup.bash ; ddsrouter --config-path resources/DDSROUTER_CONFIGURATION.yaml
