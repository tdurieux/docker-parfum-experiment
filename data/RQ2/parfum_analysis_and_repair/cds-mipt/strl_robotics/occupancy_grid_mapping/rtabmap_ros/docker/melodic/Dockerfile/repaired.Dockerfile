FROM ros:melodic-perception
# install rtabmap packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-melodic-rtabmap \
    ros-melodic-rtabmap-ros \
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
