# This is an auto generated Dockerfile for ros:desktop
# generated from docker_images/create_ros_image.Dockerfile.em
FROM ros:lunar-robot-xenial

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-lunar-desktop=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

