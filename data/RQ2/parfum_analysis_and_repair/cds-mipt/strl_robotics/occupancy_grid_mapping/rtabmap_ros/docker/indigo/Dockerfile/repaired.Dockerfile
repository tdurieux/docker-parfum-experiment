FROM ros:indigo-perception
# install rtabmap packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-indigo-rtabmap \
    ros-indigo-rtabmap-ros \
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
