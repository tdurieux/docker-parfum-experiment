from ros:melodic

RUN mkdir -p catkin_ws/src/tf_service
COPY . catkin_ws/src/tf_service

# Build and test.
RUN bash catkin_ws/src/tf_service/.ci/docker_build_catkin_ws.sh

# Source ROS setup before running as a container.
ENTRYPOINT ["catkin_ws/src/tf_service/.ci/docker_ros_entrypoint.sh"]