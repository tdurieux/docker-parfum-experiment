FROM ros:lunar-ros-core

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential && rm -rf /var/lib/apt/lists/*;

# Create ROS workspace
COPY . /ws/src/rospy_message_converter
WORKDIR /ws

# Install the package and its dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro lunar -y

# Set up the development environment
RUN /bin/bash -c "source /opt/ros/lunar/setup.bash && \
    catkin_make install"
