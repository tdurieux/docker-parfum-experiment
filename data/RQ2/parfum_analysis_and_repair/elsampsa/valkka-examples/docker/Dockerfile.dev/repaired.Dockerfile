FROM ubuntu:18.04

USER root

ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 mesa-utils glew-utils python3-numpy v4l-utils python3-pip openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-opencv python3-pil && rm -rf /var/lib/apt/lists/*;
## some additional tools
RUN apt-get install --no-install-recommends -y ffmpeg vlc wget zip build-essential cmake pkg-config swig && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /valkka
WORKDIR /valkka

## a build created at your localhost
COPY Valkka-* .
RUN dpkg -i *.deb

## download, build & install darknet python API
RUN mkdir -p /darknet
WORKDIR /darknet
## download
RUN wget https://github.com/elsampsa/darknet-python/archive/master.zip
RUN unzip master.zip
WORKDIR /darknet/darknet-python-master
## build
RUN ./easy_build.bash
## install
RUN dpkg -i build_dir/python_darknet*.deb
## copy tiny yolo weights in-place
RUN mkdir -p /root/.darknet
WORKDIR /root/.darknet
COPY data/yolov3-tiny.weights /root/.darknet/

RUN apt-get install -fy

WORKDIR /root

RUN wget https://raw.githubusercontent.com/elsampsa/valkka-examples/master/quicktest.py
