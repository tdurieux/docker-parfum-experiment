FROM rdbox/arm.ros:kinetic-ros-core

RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-kinetic-ros-base \
    && rm -rf /var/lib/apt/lists/*

