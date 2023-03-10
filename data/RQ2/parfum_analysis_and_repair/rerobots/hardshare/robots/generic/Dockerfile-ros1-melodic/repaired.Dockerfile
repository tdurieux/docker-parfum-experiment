# Base image with packages required for add-on `cam`
#
#     docker build -t rerobots/hs-generic-ros1-melodic:latest -f Dockerfile-ros1-melodic .
#
#
# SCL <scott@rerobots.net>
# Copyright (C) 2020 rerobots, Inc.

FROM rerobots/hs-generic:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install gnupg && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       tmux \
       magic-wormhole \
       ros-melodic-ros-base && rm -rf /var/lib/apt/lists/*;

RUN echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && rm -rf /var/lib/apt/lists/*;

RUN rosdep init && rosdep update

CMD ["/sbin/rerobots-hs-init.sh"]
