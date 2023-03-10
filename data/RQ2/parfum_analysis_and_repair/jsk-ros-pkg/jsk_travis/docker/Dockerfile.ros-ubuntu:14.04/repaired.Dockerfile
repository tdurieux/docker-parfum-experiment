FROM ros:indigo-ros-base

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    libboost-all-dev \
    libeigen3-dev \
    libflann-dev \
    libqhull-dev \
    libvtk5-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python-vtk tcl-vtk && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
# Install pip
# See https://github.com/pypa/pip/issues/4805 for detail.
# https://github.com/pypa/pypi-support/issues/978 requires Python >= 2.7.9
RUN apt-get update && sudo apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:longsleep/python2.7-backports
RUN apt-get update && sudo apt-get dist-upgrade -y
RUN pip install --no-cache-dir -U dlib==19.21.1

RUN apt-get update && apt-get install --no-install-recommends -y curl git wget sudo lsb-release ccache apt-cacher-ng patch man-db && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y mesa-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes -q -qq mongodb-clients mongodb-server -o Dpkg::Options::=--force-confdef && rm -rf /var/lib/apt/lists/*;

## setup EoL repository for jade
RUN echo "deb http://snapshots.ros.org/jade/final/ubuntu `lsb_release -sc` main" >> /etc/apt/sources.list.d/ros-latest.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 0xCBF125EA
RUN apt-get update && apt-get install --no-install-recommends -y ros-jade-ros-base && rm -rf /var/lib/apt/lists/*;
##

# https://github.com/pypa/pypi-support/issues/978 requires Python >= 2.7.9
RUN sudo apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository ppa:longsleep/python2.7-backports && sudo apt-get update && sudo apt-get dist-upgrade -y

RUN addgroup --gid 976 jenkins
RUN adduser --uid 983 --disabled-password --gecos "" --force-badname --ingroup jenkins user

RUN sed -i '/^%sudo/ a user ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

USER user
