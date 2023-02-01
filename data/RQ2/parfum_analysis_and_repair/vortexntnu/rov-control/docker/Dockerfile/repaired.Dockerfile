FROM ros:kinetic-ros-base

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y libeigen3-dev && \
    apt-get install --no-install-recommends -y ros-kinetic-roslint && \
    apt-get install --no-install-recommends -y ros-kinetic-eigen-conversions && \
    apt-get install --no-install-recommends -y ros-kinetic-tf-conversions && \
    cd usr/src/gtest && \
    cmake . && \
    make && \
    cp libg* /usr/lib/ && rm -rf /var/lib/apt/lists/*;

WORKDIR /catkin_ws/src
RUN bash -c "source /opt/ros/kinetic/setup.bash && catkin_init_workspace"
