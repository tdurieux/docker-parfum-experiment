FROM ros:melodic
MAINTAINER Matthew Barulic matthew.barulic@gmail.com

# Setup apt to be happy with no console input
ENV DEBIAN_FRONTEND noninteractive

# setup apt tools and other goodies we want
RUN apt-get update --fix-missing && apt-get -y install apt-utils git software-properties-common ssh && apt-get clean

# Initialize catkin workspace
RUN mkdir -p ~/catkin_ws
WORKDIR ~/catkin_ws
RUN mkdir -p src

COPY . ./src/roboracing-software

# Install all ROS dependencies that can automatically be installed
# We're ignoring rosdep keys that are only required for interacting with hardware
#RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && rosdep install -iy --from-paths ./src  --skip-keys='pointgrey_camera_driver libuvc_camera'"
RUN /bin/bash -c "rosdep install -iy --from-paths ./src  --skip-keys='pointgrey_camera_driver libuvc_camera'"
