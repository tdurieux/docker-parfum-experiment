FROM ros:galactic-ros1-bridge
ENV DEBIAN_FRONTEND noninteractive

# ROS2
RUN set -x && \
  apt-get update -y -qq && \
  : "install ROS1 and ROS2" && \
  apt-get install --no-install-recommends -y -qq \
    ros-${ROS2_DISTRO}-image-transport \
    ros-${ROS2_DISTRO}-cv-bridge \
    ros-${ROS2_DISTRO}-image-tools \
    ros-${ROS2_DISTRO}-rosbag2-bag-v2-plugins \
    ros-${ROS2_DISTRO}-ros2bag \
    ros-${ROS2_DISTRO}-rosbag2-transport \
    ros-${ROS2_DISTRO}-rosbag2-storage-default-plugins \
    python3-pip \
    python3-colcon-common-extensions && \
  pip3 install --no-cache-dir -U \
    argcomplete & && \
  : "remove cache" && \
  apt-get autoremove -y -qq && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT []
CMD ["bash"]
