FROM ros:indigo-ros-core

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential && rm -rf /var/lib/apt/lists/*;

# Create ROS workspace
COPY . /ws/src/rospy_message_converter
WORKDIR /ws

# Install the package and its dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y

# Set up the development environment
RUN /bin/bash -c "source /opt/ros/indigo/setup.bash && \
    catkin_make install"
