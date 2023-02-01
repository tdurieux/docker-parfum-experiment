FROM ros:noetic-perception
# install rtabmap packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-noetic-rtabmap \
    ros-noetic-rtabmap-ros \
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
