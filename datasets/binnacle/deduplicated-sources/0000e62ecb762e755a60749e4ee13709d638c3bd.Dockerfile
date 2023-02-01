ARG PARENT_IMAGE=ubuntu:16.04
FROM $PARENT_IMAGE

# Install ROS Kinetic and Intera SDK dependencies. Instructions obtained from:
# http://sdk.rethinkrobotics.com/intera/Workstation_Setup
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN \
  apt -qy update && \
  DEBIAN_FRONTEND=noninteractive apt -qy install \
    git-core \
    python-argparse \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-wstool \
    ros-kinetic-actionlib \
    ros-kinetic-actionlib-msgs \
    ros-kinetic-control-msgs \
    ros-kinetic-cv-bridge \
    ros-kinetic-desktop-full \
    ros-kinetic-dynamic-reconfigure \
    ros-kinetic-joystick-drivers \
    ros-kinetic-rospy-message-converter \
    ros-kinetic-rviz \
    ros-kinetic-tf2-ros \
    ros-kinetic-trajectory-msgs \
    ros-kinetic-xacro && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN \
  rosdep init && \
  rosdep update

RUN mkdir -p /root/ros_ws/src

RUN ["/bin/bash", "-c", \
  "source /opt/ros/kinetic/setup.bash && \
  cd /root/ros_ws && \
  catkin_make"]
