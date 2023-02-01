FROM osrf/ros:noetic-desktop-focal
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    git \
    clang-7 \
    clang-format-7 \
    clang-tidy-7 \
    pycodestyle \
    liborocos-kdl-dev \
    python3-catkin-tools \
    ros-noetic-libfranka \
    ros-noetic-ros-control \
    ros-noetic-eigen-conversions \
    ros-noetic-gazebo-dev \
    ros-noetic-gazebo-ros-control \
    ros-noetic-urdfdom-py \
    && rm -rf /var/lib/apt/lists/*
