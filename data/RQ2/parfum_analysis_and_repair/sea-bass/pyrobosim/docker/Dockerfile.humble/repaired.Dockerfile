# pyrobosim Dockerfile for Ubuntu 22.04 / ROS2 Humble
FROM osrf/ros:humble-desktop
SHELL ["/bin/bash", "-c"]

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y \
    apt-utils python3-pip python3-tk && rm -rf /var/lib/apt/lists/*;

# Create a colcon workspace
RUN mkdir -p /pyrobosim_ws/src/pyrobosim

# Install dependencies
COPY setup /pyrobosim_ws/src/pyrobosim/setup
RUN cd /pyrobosim_ws/src/pyrobosim/setup && ./setup_pddlstream.bash

# Install pyrobosim and testing dependencies
COPY pyrobosim /temp/pyrobosim
RUN cd /temp/pyrobosim && pip3 install --no-cache-dir .
RUN pip3 install --no-cache-dir lark pytest pytest-html

# Setup an entrypoint and working folder
COPY docker/entrypoint_humble.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /pyrobosim_ws
