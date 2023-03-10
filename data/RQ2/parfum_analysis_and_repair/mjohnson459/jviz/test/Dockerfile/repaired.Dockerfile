FROM ros:kinetic-robot

RUN apt-get update && apt-get install --no-install-recommends -y \
	ros-kinetic-rosbridge-suite \
	ros-kinetic-ros-tutorials \
	ros-kinetic-py-trees-ros && rm -rf /var/lib/apt/lists/*;


COPY catkin_ws /catkin_ws

WORKDIR /catkin_ws

RUN bash -c "/ros_entrypoint.sh catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic install"

ENV ROS_MASTER_URI="http://master:11311"

