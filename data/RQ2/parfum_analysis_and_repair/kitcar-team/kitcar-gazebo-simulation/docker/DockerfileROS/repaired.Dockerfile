ARG PARENT
FROM ${PARENT}

ARG KITCAR_REPO_PATH=/home/kitcar
ARG KITCAR_GAZEBO_SIM_PATH=$KITCAR_REPO_PATH/kitcar-gazebo-simulation/simulation

ENV GAZEBO_RESOURCE_PATH $KITCAR_GAZEBO_SIM_PATH/models:$GAZEBO_RESOURCE_PATH
ENV GAZEBO_MODEL_PATH $KITCAR_GAZEBO_SIM_PATH/models/env_db:$GAZEBO_MODEL_PATH
ENV ROS_PACKAGE_PATH $ROS_PACKAGE_PATH:$KITCAR_GAZEBO_SIM_PATH/src
ENV PYTHONPATH $PYTHONPATH:$KITCAR_REPO_PATH/kitcar-gazebo-simulation

# Copy kitcar-gazebo-simulation
COPY / $KITCAR_REPO_PATH/kitcar-gazebo-simulation
# Remove kitcar-rosbag which was cloned there before building the docker images
RUN rm -rf $KITCAR_REPO_PATH/kitcar-gazebo-simulation/kitcar-rosbag

# Rebuild simulation, because location may have changed
RUN rm -rf ${KITCAR_REPO_PATH}/kitcar-gazebo-simulation/simulation/devel ${KITCAR_REPO_PATH}/kitcar-gazebo-simulation/simulation/build
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && cd ${KITCAR_REPO_PATH}/kitcar-gazebo-simulation/simulation && catkin_make"

# Install fonts
RUN mkdir -p /usr/local/share/fonts/kitcar/
RUN cp -a "${KITCAR_REPO_PATH}/kitcar-gazebo-simulation/simulation/models/fonts/." /usr/local/share/fonts/kitcar/

# Install packages for kitcar-ros repo.
COPY docker/ros_packages.txt /ros_packages.txt
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive xargs --arg-file=/ros_packages.txt apt install -y && \
    rm -rf /var/lib/apt/lists/*