FROM ros:melodic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python-catkin-tools python-rosdep cmake \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# Create ROS workspace
COPY . /ws/src/sick_tim
WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
RUN rosdep init && rosdep update && rosdep install --from-paths src -i -y --rosdistro melodic

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
    catkin init && \
    catkin config --install -j 1 -p 1 && \
    catkin build --limit-status-rate 0.1 --no-notify && \
    catkin build --limit-status-rate 0.1 --no-notify --make-args tests"
