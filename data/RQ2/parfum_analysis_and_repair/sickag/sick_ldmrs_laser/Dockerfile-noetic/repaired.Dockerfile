FROM ros:noetic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python3-rosdep cmake git \
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
RUN  mkdir -p /ws/src

RUN /bin/bash -c "cd /ws && \
    source /opt/ros/noetic/setup.bash && \
    catkin init && \
    catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build --limit-status-rate 0.1 --no-notify"

RUN git clone -b master https://github.com/SICKAG/libsick_ldmrs.git /ws/src/libsick_ldmrs
COPY . /ws/src/sick_ldmrs_laser

WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
#DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration -y

RUN rosdep init && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install --from-paths src -i -y --rosdistro noetic

RUN /bin/bash -c "source /ws/install/setup.bash && \
    catkin build --limit-status-rate 0.1 --no-notify"
