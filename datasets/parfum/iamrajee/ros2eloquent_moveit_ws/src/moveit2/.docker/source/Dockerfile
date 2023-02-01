# moveit/moveit2:eloquent-source
# Downloads the moveit source code and install remaining debian dependencies

ARG ROS_DISTRO=eloquent
FROM moveit/moveit2:${ROS_DISTRO}-ci-testing

MAINTAINER Robert Haschke rhaschke@techfak.uni-bielefeld.de
MAINTAINER Dave Coleman dave@picknik.ai

ENV ROS_UNDERLAY /root/ws_moveit/install
WORKDIR $ROS_UNDERLAY/../src

# Commands are combined in single RUN statement with "apt/lists" folder removal to reduce image size
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#minimize-the-number-of-layers
RUN mkdir src && \
    cd src && \
    #
    # Download moveit source so that we can get necessary dependencies
    wget -q https://raw.githubusercontent.com/ros-planning/moveit2/master/moveit2.repos && \
    vcs import < moveit2.repos && \
    # Remove folders declared as COLCON_IGNORE
    find -L . -name COLCON_IGNORE -printf "%h\0" | xargs -0 rm -rf

# Update apt package list as cache is cleared in previous container
# Usually upgrading involves a few packages only (if container builds became out-of-sync)
RUN apt-get -qq update && \
    apt-get -qq dist-upgrade && \
    rosdep update && \
    rosdep install -y --from-paths . --ignore-src --rosdistro ${ROS_DISTRO} --as-root=apt:false && \
    rm -rf /var/lib/apt/lists/*

# Build the workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh &&\
    colcon build \
	        --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo \
			  --ament-cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	        --event-handlers desktop_notification- status-
