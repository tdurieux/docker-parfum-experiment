FROM nvidia/opengl:1.0-glvnd-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& echo '========== install basic apps ==========' \
	&& apt-get install --no-install-recommends -y build-essential gedit nano wget curl unzip cmake cmake-gui git mesa-utils \
	&& echo '========== install boost ==========' \
	&& apt-get install --no-install-recommends -y libboost-all-dev \
	&& echo '========== install eigen3, opencv ==========' \
	&& apt-get install --no-install-recommends -y libeigen3-dev libopencv-dev \
	&& echo '========== install pangolin dependencies ==========' \
	&& apt install --no-install-recommends -y libglew-dev libpython2.7-dev \
	&& apt install --no-install-recommends -y ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev \
	&& apt install --no-install-recommends -y libdc1394-22-dev libraw1394-dev libuvc-dev libopenni2-dev \
	&& apt install --no-install-recommends -y libjpeg-dev libpng-dev libtiff-dev libopenexr-dev && rm -rf /var/lib/apt/lists/*;

