FROM ros:kinetic-perception
# install rtabmap packages
ARG CACHE_DATE=2016-01-01
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-kinetic-rtabmap \
    ros-kinetic-rtabmap-ros \
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
