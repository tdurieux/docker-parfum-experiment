FROM ubuntu:14.04

MAINTAINER Deshraj

# We will install opencv and caffe in this container
# This container will run the CPU worker which handles the image classification,
# Decaf, POI, image stitching and training a new model.

# Basics
RUN sudo apt-get update
RUN apt-get install --no-install-recommends -y gfortran git wget unzip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# Download source code

RUN wget https://github.com/BVLC/caffe/archive/rc2.zip && unzip rc2 && mv caffe-rc2 caffe && rm rc2.zip
RUN wget -O OpenCV-2.4.11.zip https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.11/opencv-2.4.11.zip/download && unzip OpenCV-2.4.11.zip && mv opencv-2.4.11 opencv && rm OpenCV-2.4.11.zip

# OpenCV Installation

# OpenCV dependencies
RUN apt-get install --no-install-recommends -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Requirements for celery
RUN pip install --no-cache-dir celery redis numpy pillow

RUN cd /opencv && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j 4 && \
    make install

# Caffe installation

# Caffe dependencies
RUN apt-get install --no-install-recommends -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-base-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler && rm -rf /var/lib/apt/lists/*;
RUN for req in $(cat /caffe/python/requirements.txt); do pip install --no-cache-dir $req; done

RUN cd /caffe && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 4 all

RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# In order to import caffe in python
ENV PYTHONPATH /caffe/python

# Copying the required caffe model
COPY ./bvlc_reference_caffenet.caffemodel /caffe/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel

# Starting celery worker
ENV C_FORCE_ROOT TRUE


RUN pip install --no-cache-dir flower

EXPOSE 5555

WORKDIR /CloudCV_Server

CMD ["celery","-A","celeryTasks","worker","--loglevel=debug", "--logfile=/CloudCV_Server/celery.log"]

# CMD ["celery","-A","celeryTasks","flower","--broker_api=http://guest:guest@localhost:15672/api/"]
