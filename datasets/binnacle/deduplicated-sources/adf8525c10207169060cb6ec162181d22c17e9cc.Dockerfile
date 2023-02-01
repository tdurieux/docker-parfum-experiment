# This is an auto generated Dockerfile for ros:nightly
# generated from docker_images_ros2/nightly/create_ros_image.Dockerfile.em
FROM ubuntu:bionic

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y \
    bash-completion \
    dirmngr \
    gnupg2 \
    lsb-release \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# setup ros2 keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2-testing/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros2-testing.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install python packages
RUN pip3 install -U \
    argcomplete \
    colcon-common-extensions \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures

# FIXME This is a workaround for pytest not found causing builds to fail
# Following RUN statements tests for regression of https://github.com/ros2/ros2/issues/722
RUN pip3 freeze | grep pytest \
    && python3 -m pytest --version
# install ros2 packages
ENV ROS_DISTRO dashing
RUN mkdir -p /opt/ros/$ROS_DISTRO
ARG ROS2_BINARY_URL=https://ci.ros2.org/view/packaging/job/packaging_linux/lastSuccessfulBuild/artifact/ws/ros2-package-linux-x86_64.tar.bz2
RUN wget -q $ROS2_BINARY_URL -O - | \
    tar -xj --strip-components=1 -C /opt/ros/$ROS_DISTRO

# install setup files
RUN apt-get update && apt-get install -q -y \
    ros-$ROS_DISTRO-ros-workspace \
    && rm -rf /var/lib/apt/lists/*

# add custom rosdep rule files
COPY prereqs.yaml /etc/ros/rosdep/
RUN echo "yaml file:///etc/ros/rosdep/prereqs.yaml" | \
    cat - /etc/ros/rosdep/sources.list.d/20-default.list > temp && \
    mv temp /etc/ros/rosdep/sources.list.d/20-default.list
RUN rosdep update

# install dependencies
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
    && apt-get update \
    && rosdep install -y \
    --from-paths /opt/ros/$ROS_DISTRO/share \
    --ignore-src \
    --skip-keys " \
      libopensplice69 \
      rti-connext-dds-5.3.1" \
    && rm -rf /var/lib/apt/lists/*

# FIXME Remove this once rosdep detects ROS 2 packages https://github.com/ros-infrastructure/rosdep/issues/660
# ignore installed rosdep keys
ENV ROS_PACKAGE_PATH /opt/ros/$ROS_DISTRO/share

# FIXME Remove this once ament_export_interfaces respects COLCON_CURRENT_PREFIX https://github.com/ament/ament_cmake/issues/173
#Workaround hard coded paths in nightly tarball setup scripts
ARG UPSTREAM_CI_WS=/home/jenkins-agent/workspace/packaging_linux/ws
RUN mkdir -p $UPSTREAM_CI_WS && ln -s /opt/ros/$ROS_DISTRO $UPSTREAM_CI_WS/install

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
