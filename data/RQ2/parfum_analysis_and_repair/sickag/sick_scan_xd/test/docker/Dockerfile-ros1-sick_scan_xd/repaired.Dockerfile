#
# Select ROS-1 version, e.g. noetic or melodic
#

FROM osrf/ros:noetic-desktop-full
# FROM osrf/ros:melodic-desktop

#
# install ROS package
#

RUN apt-get update && apt-get install --no-install-recommends -y ros-${ROS_DISTRO}-desktop ros-${ROS_DISTRO}-rviz psmisc && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

#
# build sick_scan_xd
#

RUN mkdir -p /workspace/src
# copy or checkout sick_scan_xd to current docker container
COPY ./src /workspace/src/
# build sick_scan_xd in docker container
WORKDIR /workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh ; catkin_make_isolated --install --cmake-args -DROS_VERSION=1 -Wno-dev
RUN /bin/bash -c "echo -e \"\nsick_scan_xd catkin_make_isolated finished:\" ; ls -al /workspace/install_isolated/lib/sick_scan"

#
# launch ros package, run sick_scan_xd with MRS1104 emulator
#
CMD /bin/bash -c "cd /workspace/src/sick_scan_xd/test/scripts ; ls -al ; ./run_linux_ros1_simu_mrs1104.bash"
