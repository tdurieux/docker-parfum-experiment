FROM ros:noetic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python3-rosdep git \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# workaround for https://github.com/catkin/catkin_tools/issues/594:
# apt-get install python3-catkin-tools doesn't work because python3-trollius doesn't exist on Ubuntu Focal

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
    && apt-get install --no-install-recommends -y git python3-pip \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --user git+https://github.com/catkin/catkin_tools.git

# end workaround

# Create ROS workspace
COPY . /ws/src/navigation_experimental
WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
RUN rosdep init && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install --from-paths src -i -y --rosdistro noetic

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin init && \
    catkin config --install -j 1 -p 1 && \
    catkin build --limit-status-rate 0.1 --no-notify && \
    catkin build --limit-status-rate 0.1 --no-notify --make-args tests"
