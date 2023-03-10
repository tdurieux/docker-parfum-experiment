FROM ros:melodic-ros-core

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential python-catkin-tools python-rosdep cmake git \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# Create ROS workspace
RUN  mkdir -p /ws/src

RUN /bin/bash -c "cd /ws && \
    source /opt/ros/melodic/setup.bash && \
    catkin init && \
    catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build --limit-status-rate 0.1 --no-notify"

COPY . /ws/src/sick_ldmrs_laser
RUN git clone -b master https://github.com/SICKAG/libsick_ldmrs.git /ws/src/libsick_ldmrs

WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
RUN rosdep init && rosdep update && rosdep install --from-paths src -i -y --rosdistro melodic

RUN /bin/bash -c "source /ws/install/setup.bash && \
    catkin build --limit-status-rate 0.1 --no-notify"
