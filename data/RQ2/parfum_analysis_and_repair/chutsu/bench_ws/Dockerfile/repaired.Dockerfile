FROM ros:melodic-perception-bionic

SHELL ["/bin/bash", "-c"]
ENV HOME /root

# Install basic things
RUN apt-get update -yq
RUN apt-get update && apt-get install --no-install-recommends -qq -y \
  sudo \
  lsb-release \
  build-essential \
  git \
  cmake \
  vim \
  vifm \
  wget \
  libv4l-dev \
  libboost-dev \
  libceres-dev \
  libeigen3-dev \
  libeigen3-doc \
  libgtest-dev \
  libopencv-* \
  libyaml-cpp-dev \
  libglew-dev \
  python-catkin-tools \
  python-rosdep \
  python-igraph \
  python3-dev \
  python3-pip \
  python3-matplotlib \
  python3-matplotlib-dbg \
  ros-melodic-random-numbers \
  ros-melodic-pcl-conversions \
  ros-melodic-pcl-msgs \
  ros-melodic-pcl-ros \
  ros-melodic-cv-bridge \
  ros-melodic-image-transport \
  ros-melodic-message-filters \
  ros-melodic-tf \
  ros-melodic-tf-conversions \
  ros-melodic-rosbag && rm -rf /var/lib/apt/lists/*;

# Check to $HOME
WORKDIR $HOME
RUN mkdir -p bench_ws
COPY ./ bench_ws

# Build bench_ws
WORKDIR $HOME/bench_ws
RUN make build
