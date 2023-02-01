FROM ros:kinetic-ros-core

RUN apt-get update && apt-get install -y \
    build-essential python-catkin-tools python-catkin-lint

# Create ROS workspace
COPY . /ws/src/mir_robot
WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
RUN rosdep install --from-paths src -i -y --rosdistro kinetic

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
    catkin init && \
    catkin config --install -j 1 -p 1 && \
    catkin build --limit-status-rate 0.1 --no-notify && \
    catkin build --limit-status-rate 0.1 --no-notify --make-args tests"
