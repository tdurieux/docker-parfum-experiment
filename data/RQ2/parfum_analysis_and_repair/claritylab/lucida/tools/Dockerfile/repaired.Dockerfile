####
# Builds the lucida base image
FROM ubuntu:14.04

#### environment variables
ENV LUCIDAROOT /usr/local/lucida/lucida
ENV LD_LIBRARY_PATH /usr/local/lib

ENV OPENCV_VERSION 2.4.9
ENV THRIFT_VERSION 0.9.3
ENV THREADS 4
ENV PROTOBUF_VERSION 2.5.0
ENV JAVA_VERSION 8
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

#### common package installations
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas3-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libdouble-conversion-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblz4-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y binutils-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjemalloc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtesseract-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-base-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libiberty-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsox-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf-archive && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y subversion && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libprotoc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y flac && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gawk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgflags-dev libgoogle-glog-dev liblmdb-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libleveldb-dev libsnappy-dev libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y flex && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsasl2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnuma-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y scons && rm -rf /var/lib/apt/lists/*;

#### package specific routines
RUN \
  echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java$JAVA_VERSION-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk$JAVA_VERSION-installer

## install MongoDB, OpenCV, Thrift, and FBThrift
RUN mkdir -p /usr/local/lucida
ADD . /usr/local/lucida/tools
WORKDIR "/usr/local/lucida/tools"
RUN /bin/bash apt_deps.sh
RUN /bin/bash install_mongodb.sh
RUN /bin/bash install_opencv.sh
RUN /bin/bash install_thrift.sh
RUN /bin/bash install_fbthrift.sh
RUN \
  rm -rf mongo-c-driver/ && \
  rm -rf mongo-cxx-driver/ && \
  rm -rf fbthrift/ && \
  rm -rf libbson/ && \
  rm -rf opencv-2.4.9/
