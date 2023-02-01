#
# PX4 full ROS container
#
# License: according to LICENSE.md in the root directory of the PX4 Firmware repository

FROM ubuntu:14.04.1
MAINTAINER Andreas Antener <andreas@uaventure.com>

# Install basics
## Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get -y --no-install-recommends install wget git mercurial && rm -rf /var/lib/apt/lists/*;

# Main ROS Setup
# Following http://wiki.ros.org/indigo/Installation/Ubuntu
# Also adding dependencies for gazebo http://gazebosim.org/tutorials?tut=drcsim_install

## add ROS repositories and keys
## install main ROS pacakges
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list \
	&& wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add - \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install ros-indigo-desktop-full && rm -rf /var/lib/apt/lists/*;

RUN rosdep init \
	&& rosdep update

## setup environment variables
RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc

## get rosinstall
RUN apt-get -y --no-install-recommends install python-rosinstall && rm -rf /var/lib/apt/lists/*;

## additional dependencies
RUN apt-get -y --no-install-recommends install ros-indigo-octomap-msgs ros-indigo-joy && rm -rf /var/lib/apt/lists/*;

## install drcsim
RUN echo "deb http://packages.osrfoundation.org/drc/ubuntu trusty main" > /etc/apt/sources.list.d/drc-latest.list \
	&& wget https://packages.osrfoundation.org/drc.key -O - | apt-key add - \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install drcsim && rm -rf /var/lib/apt/lists/*;

# Install x11-utils to get xdpyinfo, for X11 display debugging
# mesa-utils provides glxinfo, handy for understanding the 3D support
RUN apt-get -y --no-install-recommends install x11-utils mesa-utils && rm -rf /var/lib/apt/lists/*;

# Some QT-Apps/Gazebo don't not show controls without this
ENV QT_X11_NO_MITSHM 1

# FIXME: this doesn't work when building from vagrant
COPY scripts/setup-workspace.sh /root/scripts/
RUN chmod +x -R /root/scripts/*
RUN chown -R root:root /root/scripts/*

CMD ["/usr/bin/xterm"]
