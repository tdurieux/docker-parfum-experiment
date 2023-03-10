FROM ros:kinetic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python-rosdep cmake \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# Create ROS workspace
COPY . /ws/src/navigation_experimental
WORKDIR /ws

# Install the package and its dependencies
RUN rosdep init && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install --from-paths src --ignore-src --rosdistro kinetic -y

# Set up the development environment
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
    catkin_make install"
