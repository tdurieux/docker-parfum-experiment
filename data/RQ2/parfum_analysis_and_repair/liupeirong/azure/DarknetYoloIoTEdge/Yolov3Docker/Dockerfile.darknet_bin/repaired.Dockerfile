FROM ubuntu:16.04
FROM python:3.5
MAINTAINER Paige Liu <pliu@microsoft.com>

RUN apt-get update \
&& apt-get -y upgrade \
&& apt-get install --no-install-recommends -y \
        git \
        wget \
        unzip \
        libopencv-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir opencv-python==3.4.0.12 \
&& pip install --no-cache-dir opencv-contrib-python \
&& git clone https://github.com/pjreddie/darknet.git \
&& cd darknet \
&& sed -i "s/OPENCV=0/OPENCV=1/g" Makefile \
&& make \
&& wget https://pjreddie.com/media/files/yolov3.weights
