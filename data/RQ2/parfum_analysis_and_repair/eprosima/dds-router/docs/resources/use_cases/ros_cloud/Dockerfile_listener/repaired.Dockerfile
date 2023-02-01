FROM ros:galactic

SHELL ["/bin/bash", "-c"]

# Install demo-nodes-cpp
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    apt update && \
    apt install --no-install-recommends -y ros-$ROS_DISTRO-rmw-fastrtps-cpp && \
    apt install --no-install-recommends -y ros-$ROS_DISTRO-demo-nodes-cpp && rm -rf /var/lib/apt/lists/*;

# Set Fast DDS as middleware
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp

COPY ./run.bash /
RUN chmod +x /run.bash

# Setup entrypoint
ENTRYPOINT ["/run.bash"]
