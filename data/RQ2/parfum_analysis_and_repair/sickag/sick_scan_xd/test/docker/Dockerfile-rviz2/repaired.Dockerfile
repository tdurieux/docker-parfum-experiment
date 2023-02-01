FROM osrf/ros:foxy-desktop
# install ros package
RUN apt-get update && apt-get install --no-install-recommends -y ros-${ROS_DISTRO}-desktop ros-${ROS_DISTRO}-rviz2 && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*
# launch ros package
CMD ["ros2", "run", "rviz2", "rviz2"]
