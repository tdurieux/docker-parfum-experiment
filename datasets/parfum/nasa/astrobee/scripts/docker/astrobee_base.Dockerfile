# This will set up an Astrobee melodic docker container using the non-NASA install
# instructions.
# This image is the base, meaning that it contains all the installation context,
# but it doesn't copy or build the entire code.
# You must set the docker context to be the repository root directory

ARG UBUNTU_VERSION=16.04
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu$UBUNTU_VERSION

ARG ROS_VERSION=kinetic
ARG PYTHON=''

# try to suppress certain warnings during apt-get calls
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install of apt-utils suppresses bogus warnings later
RUN apt-get update \
  && apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
  && apt-get install -y \
  build-essential \
  git \
  lsb-release \
  sudo \
  wget \
  && rm -rf /var/lib/apt/lists/*

# suppress detached head warnings later
RUN git config --global advice.detachedHead false

# Install ROS --------------------------------------------------------------------
COPY ./scripts/setup/*.sh /setup/astrobee/

# this command is expected to have output on stderr, so redirect to suppress warning
RUN /setup/astrobee/add_ros_repository.sh >/dev/null 2>&1

RUN apt-get update \
  && apt-get install -y \
  debhelper \
  libtinyxml-dev \
  ros-${ROS_VERSION}-desktop \
  python${PYTHON}-rosdep \
  && rm -rf /var/lib/apt/lists/*

# Install Astrobee----------------------------------------------------------------
COPY ./scripts/setup/debians /setup/astrobee/debians

RUN apt-get update \
  && /setup/astrobee/debians/build_install_debians.sh \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /setup/astrobee/debians

COPY ./scripts/setup/packages_*.lst /setup/astrobee/
# note apt-get update is run within the following shell script
RUN /setup/astrobee/install_desktop_packages.sh \
  && rm -rf /var/lib/apt/lists/*

#Add the entrypoint for docker
RUN echo "#!/bin/bash\nset -e\n\nsource \"/opt/ros/${ROS_VERSION}/setup.bash\"\nsource \"/src/astrobee/devel/setup.bash\"\nexport ASTROBEE_CONFIG_DIR=\"/src/astrobee/src/astrobee/config\"\nexec \"\$@\"" > /astrobee_init.sh && \
  chmod +x /astrobee_init.sh && \
  rosdep init && \
  rosdep update 2>&1 | egrep -v 'as root|fix-permissions'
