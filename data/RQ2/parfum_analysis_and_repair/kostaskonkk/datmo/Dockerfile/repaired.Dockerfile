FROM ros:noetic-perception

RUN mkdir -p /home/datmo

SHELL ["/bin/bash", "-c"]

# install/setup prerequisites
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Setup catkin workspace
RUN source /opt/ros/noetic/setup.bash && \
    mkdir -p ~/catkin_ws/src && \
    cd ~/catkin_ws/src  && \
    git clone https://github.com/kostaskonkk/datmo.git &&\
    cd ~/catkin_ws &&\
    catkin_make && \
    source devel/setup.bash
