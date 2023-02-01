FROM ubuntu:focal

# setup sources.list
RUN apt-get update && apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN echo "deb http://packages.ros.org/ros-testing/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list

# install
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-noetic-ros-comm \
    ros-noetic-roscpp-tutorials \
    ros-noetic-rospy-tutorials \
    && rm -rf /var/lib/apt/lists/*

#
RUN apt-get update && apt-get install --no-install-recommends -y python3-rosdep && rm -rf /var/lib/apt/lists/*;
RUN rosdep init && rosdep update

ENV ROS_DISTRO noetic

# FROM ros:noetic-ros-base

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    libboost-all-dev \
    libeigen3-dev \
    libflann-dev \
    libqhull-dev \
    libvtk6-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U dlib

RUN apt-get update && apt-get install --no-install-recommends -y curl git wget sudo lsb-release ccache apt-cacher-ng patch man-db && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y mesa-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes -q -qq mongodb-clients mongodb-server -o Dpkg::Options::=--force-confdef && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN addgroup --gid 976 jenkins
RUN adduser --uid 983 --disabled-password --gecos "" --force-badname --ingroup jenkins user

RUN sed -i '/^%sudo/ a user ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

USER user
