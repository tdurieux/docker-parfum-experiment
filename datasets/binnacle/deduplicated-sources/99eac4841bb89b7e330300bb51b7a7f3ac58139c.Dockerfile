# This is an auto generated Dockerfile for ros:desktop
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:dashing-ros-base-bionic
# install ros2 packages
RUN apt-get update && apt-get install -y \
    ros-dashing-desktop=0.7.2-1* \
    && rm -rf /var/lib/apt/lists/*

