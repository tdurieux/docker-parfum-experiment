FROM ros:noetic
LABEL maintainer="bernd.pfrommer@gmail.com"
LABEL version="1.0"
LABEL description="custom Docker Image for building ROS packages"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update

# for add-apt-repository
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

# will need opencv and git
RUN apt-get -y --no-install-recommends install git libopencv-dev && rm -rf /var/lib/apt/lists/*;

# I need emacs to function
RUN apt-get -y --no-install-recommends install emacs && rm -rf /var/lib/apt/lists/*;

# libceres is used in e.g. multicam-calibration
RUN apt-get -y --no-install-recommends install libceres-dev && rm -rf /var/lib/apt/lists/*;
#
# some additional ROS packages
#
RUN apt-get -y --no-install-recommends install python3-osrf-pycommon python3-catkin-tools ros-${ROS_DISTRO}-image-transport ros-${ROS_DISTRO}-cv-bridge ros-${ROS_DISTRO}-sensor-msgs ros-${ROS_DISTRO}-std-msgs ros-${ROS_DISTRO}-rosbag ros-${ROS_DISTRO}-eigen-conversions ros-${ROS_DISTRO}-tf2-ros ros-${ROS_DISTRO}-image-geometry ros-${ROS_DISTRO}-tf2-geometry-msgs ros-${ROS_DISTRO}-message-generation ros-${ROS_DISTRO}-message-runtime ros-${ROS_DISTRO}-dynamic-reconfigure && rm -rf /var/lib/apt/lists/*;
