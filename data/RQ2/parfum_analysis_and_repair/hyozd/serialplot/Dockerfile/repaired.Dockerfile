FROM ubuntu:bionic

# Install build dependencies
RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:beineri/opt-qt-5.15.2-bionic
RUN apt-get -y --no-install-recommends install build-essential mesa-common-dev qt515base qt515serialport qt515svg cmake mercurial subversion git wget libfuse2 && rm -rf /var/lib/apt/lists/*;

# Define environment variable
ENV PATH /opt/qt515/bin/:$PATH

WORKDIR /serialplot
ADD . /serialplot
WORKDIR ./build_docker
RUN cmake ../ && make -j appimage
