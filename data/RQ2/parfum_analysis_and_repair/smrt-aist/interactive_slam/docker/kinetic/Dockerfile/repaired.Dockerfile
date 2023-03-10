FROM ros:kinetic

RUN apt-get update && apt-get install --no-install-recommends -y \
 && apt-get install --no-install-recommends -y wget nano build-essential \
 ros-kinetic-geodesy ros-kinetic-pcl-ros ros-kinetic-nmea-msgs ros-kinetic-rviz \
 ros-kinetic-tf-conversions ros-kinetic-libg2o libglm-dev libglfw3-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_init_workspace'
RUN git clone https://github.com/koide3/ndt_omp.git
RUN git clone https://github.com/koide3/hdl_graph_slam.git
RUN git clone https://github.com/SMRT-AIST/fast_gicp.git --recursive

# RUN git clone https://github.com/koide3/interactive_slam.git --recursive
COPY . /root/catkin_ws/src/interactive_slam/
WORKDIR /root/catkin_ws/src/interactive_slam
RUN git submodule init
RUN git submodule update

WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_make'
RUN sed -i "6i source \"/root/catkin_ws/devel/setup.bash\"" /ros_entrypoint.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]