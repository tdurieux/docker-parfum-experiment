FROM ros:kinetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update

SHELL ["bash", "-c"]
RUN mkdir -p /ws/src/#####ROS_PACKAGE#####
COPY . /ws/src/#####ROS_PACKAGE#####
ENV ROS_PACKAGE_PATH=/ws/src/#####ROS_PACKAGE#####
RUN rosdep install -y -r --from-path /ws/src
RUN source /opt/ros/$ROS_DISTRO/setup.bash;\
 cd /ws/src;\
 catkin_init_workspace;\
 cd /ws;\
 catkin_make

RUN sed -i "6iexport ROS_IP=\$\(hostname -I\)" /ros_entrypoint.sh
RUN sed -i "6isource /ws/devel/setup.bash" /ros_entrypoint.sh

RUN rm -rf /var/lib/apt/lists/*

CMD #####CMD#####