# TODO(Josecisneros001): Add Navigation Stack
FROM osrf/ros:noetic-desktop-full

LABEL maintainer="Jose Cisneros <A01283070@itesm.mx>"

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    nano \
    git \
    autoconf \
    libtool \
    python3-pip \
    mesa-utils \
    --no-install-recommends terminator \
    ros-noetic-audio-common \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-moveit-ros-planning \
    ros-noetic-moveit-ros-planning-interface \
    ros-noetic-moveit-core \
    ros-noetic-moveit-msgs \
    ros-noetic-rosserial-arduino \ 
    ros-noetic-rosserial && \
    rm -rf /var/lib/apt/lists/*

# Init catkin_home directoy
RUN mkdir /catkin_home
COPY catkin_home/ catkin_home/

# Change Workdir
WORKDIR /catkin_home

# catkin_make
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash;catkin_make'

# Base Control Dependency
RUN /bin/bash -c 'mkdir -p /Arduino/libraries;cd /Arduino/libraries;. /catkin_home/devel/setup.bash;rosrun rosserial_arduino make_libraries.py . '

# Add ROS environment variables automatically