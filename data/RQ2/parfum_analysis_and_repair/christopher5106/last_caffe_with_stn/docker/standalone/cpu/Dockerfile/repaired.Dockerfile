FROM ubuntu:14.04
MAINTAINER caffe-maint@googlegroups.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*


ENV OPENCV_ROOT=/opt/opencv
RUN mkdir -p $OPENCV_ROOT
WORKDIR $OPENCV_ROOT
RUN git clone https://github.com/Itseez/opencv.git .
RUN apt-get install --no-install-recommends -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev && rm -rf /var/lib/apt/lists/*;
#libtbb2 libtbb-dev
RUN mkdir -p $OPENCV_ROOT/release
WORKDIR $OPENCV_ROOT/release
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
RUN make -j"$(nproc)"
RUN sudo make install

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/christopher5106/last_caffe_with_stn.git . && \
    for req in $(cat python/requirements.txt) pydot; do pip install --no-cache-dir $req; done && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace
