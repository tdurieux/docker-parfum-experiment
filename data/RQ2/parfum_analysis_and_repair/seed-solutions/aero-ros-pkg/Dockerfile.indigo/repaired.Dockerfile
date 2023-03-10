FROM ros:indigo-robot
SHELL ["bash", "-c"]

ENV MY_DISTRO indigo
ENV WORKSPACE /catkin_ws

ARG RUN_TESTS=false

# prepare catkin and all euslisp packages
RUN apt-get -q -qq update \
    && apt-get -q -qq dist-upgrade -y \
    && apt-get -q --no-install-recommends -qq install -y \
    ros-${MY_DISTRO}-catkin \
    python-wstools python-catkin-tools \
    bc net-tools iputils-ping && rm -rf /var/lib/apt/lists/*;

# create catkin workspace
RUN mkdir -p ${WORKSPACE}/src/aero-ros-pkg
WORKDIR ${WORKSPACE}
RUN wstool init ${WORKSPACE}/src
COPY . ${WORKSPACE}/src/aero-ros-pkg/

# catkin build
WORKDIR ${WORKSPACE}
RUN source /opt/ros/${MY_DISTRO}/setup.bash \
    && rosdep install -q -y -r --from-paths src --ignore-src \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

RUN source /opt/ros/${MY_DISTRO}/setup.bash \
    && catkin config --init
RUN source /opt/ros/${MY_DISTRO}/setup.bash \
    && catkin build aero_description

WORKDIR ${WORKSPACE}/src/aero-ros-pkg/aero_description
RUN source ${WORKSPACE}/devel/setup.bash \
    && ./setup.sh typeF

WORKDIR ${WORKSPACE}
## build check
RUN source ${WORKSPACE}/devel/setup.bash \
    && catkin build aero_std
RUN source ${WORKSPACE}/devel/setup.bash \
    && catkin build aero_samples
RUN source ${WORKSPACE}/devel/setup.bash \
    && catkin build aero_gazebo

## test
RUN if [ "$RUN_TESTS" = "true" ]; then \
    source ${WORKSPACE}/devel/setup.bash \
    && catkin run_tests --no-deps aero_ros_controller \
    && catkin_test_results ${WORKSPACE}/build/aero_ros_controller; fi
RUN if [ "$RUN_TESTS" = "true" ]; then \
    source ${WORKSPACE}/devel/setup.bash \
    && catkin run_tests --no-deps aero_std \
    && catkin_test_results ${WORKSPACE}/build/aero_std; fi
RUN if [ "$RUN_TESTS" = "true" ]; then \
    source ${WORKSPACE}/devel/setup.bash \
    && catkin run_tests --no-deps aero_samples \
    && catkin_test_results ${WORKSPACE}/build/aero_samples; fi
