FROM osrf/ros:kinetic-desktop-xenial
RUN apt-get update && apt-get install --no-install-recommends -y \
    clang-5.0 \
    clang-format-5.0 \
    clang-tidy-5.0 \
    ros-kinetic-ros-control \
    && rm -rf /var/lib/apt/lists/*
