FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y cython python-dev libopenscenegraph-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjansson-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install instructions from http://wiki.ros.org/noetic/Installation/Ubuntu
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal restricted universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal-updates restricted universe multiverse"
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get -y update && apt-get -y dist-upgrade

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y ros-noetic-desktop-full && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y ros-noetic-ros-base

RUN chmod a+x /opt/ros/noetic/setup.bash

# This is specified already in package.xml. Why doesn't catkin install it?
RUN apt-get install --no-install-recommends -y libopenexr-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-rosdep && rm -rf /var/lib/apt/lists/*;
RUN rosdep init
RUN ls -l /etc/ros/rosdep/sources.list.d

RUN echo 'yaml https://raw.githubusercontent.com/strawlab/rosdistro/noetic/rosdep.yaml' > /etc/ros/rosdep/sources.list.d/40-strawlab-noetic.list
RUN rosdep update

ADD . /catkin_ws/src/freemovr_engine

RUN rosdep install -y --from-paths /catkin_ws --rosdistro=noetic
# RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && rosdep install --from-paths /catkin_ws --rosdistro=noetic'

RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && mkdir -p /catkin_ws/src && cd /catkin_ws/ && catkin_make'
