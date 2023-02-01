FROM ubuntu:16.04
LABEL maintainer="alberto dot soragna at gmail dot com"

# working directory
ENV HOME /root
WORKDIR $HOME

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# general utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    curl \
    git \
    vim \
    nano \
    python-dev \
    python3-pip \
    ipython && rm -rf /var/lib/apt/lists/*;

# pip
RUN pip3 install --no-cache-dir --upgrade pip


#### ROS2 SETUP


# Locale options
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# setup sources
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://repo.ros2.org/repos.key | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

# ROS setup requirements
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install -U \
  argcomplete \
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

# install additional ubuntu 16.04 requirements
RUN python3 -m pip install -U \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools

# install Fast-RTPS dependencies
RUN apt-get install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev \
  libopensplice67 && rm -rf /var/lib/apt/lists/*;

# create ros2 sdk workspace
RUN mkdir -p $HOME/ros2_sdk/src
WORKDIR $HOME/ros2_sdk
RUN wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
RUN vcs import src < ros2.repos

# initialize rosdep and install dependencies
RUN rosdep init
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src --rosdistro bouncy -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 rti-connext-dds-5.3.1 urdfdom_headers"

# build the workspace
RUN colcon build --symlink-install


#### TENSORFLOW SETUP


# install tensorflow
#RUN export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
RUN pip install --no-cache-dir tensorflow

RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir matplotlib opencv-python

#### SET ENVIRONMENT

WORKDIR $HOME

RUN echo ' \n\
echo "Sourcing ROS2 and Turtlebot packages..." \n\
source $HOME/ros2_sdk/install/setup.sh' >> $HOME/.bashrc

RUN echo ' \n\
alias python="python3"' >> $HOME/.bashrc



