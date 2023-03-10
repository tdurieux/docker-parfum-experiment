FROM ros:galactic-ros-core-focal

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-galactic-ros-base=0.9.3-2* && rm -rf /var/lib/apt/lists/*;

# Everything above this line comes from:
# https://github.com/osrf/docker_images/blob/master/ros/galactic/ubuntu/focal/ros-base/Dockerfile

# Below this line, twistedfields additions.

RUN apt update && apt install --no-install-recommends -y libffi-dev \
                  python3-dev curl \
                  libkrb5-dev \
                  libzmq5 \
                  libblas-dev \
                  redis \
                  automake \
                  subversion \
                  libxml2-dev \
                  libxslt1-dev \
                  gfortran-arm-linux-gnueabi \
                  libjpeg8-dev \
                  python3-pip \
                  python3-scipy \
                  python3-numpy-dev \
                  tmux \
                  vim \
                  mercurial \
                  iw \
                  bash \
                  iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install wheel certifi==2020.06.20 pytest==6.2.5 coverage[toml]
COPY server/requirements.txt /install/server/
RUN python3 -m pip install -r /install/server/requirements.txt
COPY vehicle/requirements.txt /install/vehicle/
RUN python3 -m pip install -r /install/vehicle/requirements.txt
COPY bringup/ODriveAcorn /install/bringup/ODriveAcorn
RUN cd /install/bringup/ODriveAcorn/tools/ && python3 /install/bringup/ODriveAcorn/tools/fibre/python/setup.py install
RUN cd /install/bringup/ODriveAcorn/tools/ && python3 /install/bringup/ODriveAcorn/tools/setup.py install
RUN cd /install/bringup/ODriveAcorn/tools/fibre/python/ && python3 setup.py install
RUN python3 -m pip install adafruit-circuitpython-mcp230xx coloredlogs pyserial_asyncio pyubx2 pygame
RUN apt update && apt install --no-install-recommends -y libraspberrypi-bin; rm -rf /var/lib/apt/lists/*; exit 0
