FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

ENV DEBIAN_FRONTEND=noninteractive
COPY scripts/ros_kinetic_setup.sh /root
RUN apt-get update \
	&& apt-get upgrade -y \
	&& echo -e '\n========== install ros ==========' \
	&& chmod a+x /root/ros_kinetic_setup.sh \
	&& /root/ros_kinetic_setup.sh \
	&& echo -e '\n========== install basic apps ==========' \
	&& apt-get install --no-install-recommends -y build-essential gedit nano wget curl unzip cmake git mesa-utils \
	&& echo -e '\n========== install pythons ==========' \
	&& apt-get install --no-install-recommends -y libpython2.7-dev libpython3.5-dev python-pip python3-pip python3-pandas python3-numpy \
	&& echo '========== install boost ==========' \
	&& apt-get install --no-install-recommends -y libboost-all-dev \
	&& echo '========== install eigen3, opencv ==========' \
	&& apt-get install --no-install-recommends -y libeigen3-dev libopencv-dev \
	&& echo '========== install pangolin dependencies ==========' \
	&& apt install --no-install-recommends -y libglew-dev \
	&& apt install --no-install-recommends -y ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev \
	&& apt install --no-install-recommends -y libdc1394-22-dev libraw1394-dev libopenni2-dev \
	&& apt install --no-install-recommends -y libjpeg-dev libpng-dev libtiff-dev libopenexr-dev \
	&& echo -e '\n========== install maplab dependencies ==========' \
	&& apt install --no-install-recommends -y autotools-dev ccache doxygen dh-autoreconf clang-format-3.8 \
	&& apt install --no-install-recommends -y liblapack-dev libblas-dev libgtest-dev libv4l-dev libatlas3-base \
	&& apt install --no-install-recommends -y libreadline-dev libssh2-1-dev pylint python-autopep8 python-catkin-tools \
	&& apt install --no-install-recommends -y python-git python-setuptools python-termcolor python-wstool \
	&& echo '========== install ceres dependencies ==========' \
	&& apt install --no-install-recommends -y libeigen3-dev libsuitesparse-dev libgoogle-glog-dev libatlas-base-dev libtbb-dev \
	&& echo -e '\n========== install optional utils ==========' \
	&& apt-get install --no-install-recommends -y rpl silversearcher-ag cmake-gui \
	&& pip3 install --no-cache-dir pipenv && rm -rf /var/lib/apt/lists/*;

