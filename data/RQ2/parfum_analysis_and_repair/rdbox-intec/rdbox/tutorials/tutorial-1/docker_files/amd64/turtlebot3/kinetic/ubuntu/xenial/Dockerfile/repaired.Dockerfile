FROM ros:kinetic-ros-base-xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-kinetic-turtlebot3 \
    && rm -rf /var/lib/apt/lists/*

