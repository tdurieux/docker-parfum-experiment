FROM ros:kinetic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python-rosdep cmake \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

RUN rosdep init && rosdep update --include-eol-distros

# Create ROS workspace
COPY . /ws/src/rospy_message_converter
WORKDIR /ws

# Install the package and its dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro kinetic -y

# Set up the development environment
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
    catkin_make install"
