# moveit/moveit2:crystal-release
# Full debian-based install of MoveIt! using apt-get
# TODO(mlautman): Add this Dockerfile to DockerHub once the moveit2 debians are released

FROM ros:crystal-ros-base-bionic
MAINTAINER Dave Coleman dave@picknik.ai

# Commands are combined in single RUN statement with "apt/lists" folder removal to reduce image size
RUN apt-get update && \
    apt-get install -y ros-${ROS_DISTRO}-moveit-* && \
    rm -rf /var/lib/apt/lists/*
