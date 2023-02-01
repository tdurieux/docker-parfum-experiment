FROM ros:indigo
RUN apt-get clean
RUN apt-get update && apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;

# Install rosbridge
COPY ./rosbridge /rosbridge_ws/src/rosbridge
RUN rosdep install --from-paths /rosbridge_ws/src --ignore-src --rosdistro=$ROS_DISTRO -y
RUN . /opt/ros/indigo/setup.sh; catkin_make -C /rosbridge_ws

EXPOSE 9090
