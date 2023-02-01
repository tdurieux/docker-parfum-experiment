FROM docker.io/ubuntu:hirsute

# update aptitude
ENV TZ=Europe/Zurich
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y --fix-missing upgrade

# install aptitude essentials
RUN apt-get -y install build-essential
RUN apt-get -y install git
RUN apt-get -y install vim
RUN apt-get -y install rsync
RUN apt-get -y install curl
RUN apt-get -y install gdb
RUN apt-get -y install libgsl-dev
RUN apt-get -y install wget
RUN apt-get -y install pkg-config
RUN apt-get -y install python3-dev
RUN apt-get -y install python3-pip
RUN apt-get -y install python3-numpy
RUN apt-get -y install python3-matplotlib
RUN apt-get -y install python3-scipy
RUN apt-get -y install python3-xlrd
RUN apt-get -y install python3-pandas
RUN apt-get -y install libdnnl-dev
RUN apt-get -y install libopenmpi-dev

RUN python3 -m pip install meson
RUN python3 -m pip install ninja
RUN python3 -m pip install cmake
RUN python3 -m pip install pybind11

WORKDIR /home/ubuntu
RUN git clone https://github.com/cselab/korali.git
RUN cd korali; CC=gcc CXX=g++ meson setup build --prefix=/usr/local --buildtype=release -Donednn=true -Dmpi=true
RUN cd korali; ninja -C build
RUN cd korali; meson install -C build
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages/:$PYTHONPATH
