#From inside this folder
# docker build -t cogrob/ebt-dev .
# docker run -t -i -v /path/to/local/ebt/repo:~/git/ebt  cogrob/ebt-dev /bin/bash
# docker export ebt-dev | gzip -c > ebt-dev.tgz
# docker import ebt-dev < ebt-dev.tgz

############################################################
# Dockerfile to build EBT images
# Based on Ubuntu
############################################################

FROM cogrob/ebt-dep
MAINTAINER Cognitive Robotics "http://cogrob.org/"

RUN apt-get install --no-install-recommends -y \
	cmake \
	cmake-curses-gui \
	libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# libglide3 glew-utils libxcb-doc libxext-doc

RUN apt-get install --no-install-recommends -y \
	libglew-dev \
	freeglut3-dev \
	liblapack3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
	build-essential \
	libxmu-dev \
	libxi-dev \
	checkinstall \
	libgtk2.0-dev \
	pkg-config && rm -rf /var/lib/apt/lists/*;

# RUN apt-get -y install libflann-dev
# RUN apt-get -y install libgsl0-dev
# RUN apt-get -y install libgoogle-perftools-dev