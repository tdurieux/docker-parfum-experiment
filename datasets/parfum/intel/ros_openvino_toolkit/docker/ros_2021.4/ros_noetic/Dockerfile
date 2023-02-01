# ros openvino toolkit env master f1b1ca4d914186a1881b87f103be9c6e910c9d80

from osrf/ros:noetic-desktop-full

# setting proxy env --option 
ENV http_proxy=http://child-prc.intel.com:913
ENV https_proxy=http://child-prc.intel.com:913

# maintainer information
LABEL maintainer="Pengqiang Li <pengqiang.li@intel.com>"

SHELL ["/bin/bash", "-c"]

# ignore the warning
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes apt-utils
RUN apt-get install -y git

# install openvino 2021.4
# https://docs.openvinotoolkit.org/latest/openvino_docs_install_guides_installing_openvino_apt.html
RUN apt update && apt install curl gnupg2 lsb-release
RUN curl -s https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021 |apt-key add -
RUN echo "deb https://apt.repos.intel.com/openvino/2021 all main" | tee /etc/apt/sources.list.d/intel-openvino-2021.list
RUN apt update
RUN apt-cache search openvino
RUN apt-get install -y intel-openvino-dev-ubuntu20-2021.4.582 
RUN ls -lh /opt/intel/openvino_2021
RUN source /opt/intel/openvino_2021/bin/setupvars.sh 

# install librealsense2
RUN apt-get install -y --no-install-recommends \
software-properties-common 
# https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md
RUN apt-key adv --keyserver-options http-proxy=http://child-prc.intel.com:913/ --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || apt-key adv --keyserver-options http-proxy=http://child-prc.intel.com:913/ --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE 
RUN add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo bionic main" -u \
&& apt-get install -y --no-install-recommends \
librealsense2-dkms \
librealsense2-utils \
librealsense2-dev \
librealsense2-dbg \
libgflags-dev \
libboost-all-dev \
&& rm -rf /var/lib/apt/lists/*

# build ros openvino toolkit
#RUN apt-get install -y git
WORKDIR /root
RUN mkdir -p ros_ws/src
WORKDIR /root/ros_ws/src
RUN git clone https://github.com/intel/object_msgs.git
RUN git clone -b noetic https://github.com/pqLee/ros_openvino_toolkit.git
RUN git clone -b noetic https://github.com/ros-perception/vision_opencv.git
WORKDIR /root/ros_ws
RUN source /opt/ros/noetic/setup.bash && source /opt/intel/openvino_2021/bin/setupvars.sh && catkin_make_isolated
